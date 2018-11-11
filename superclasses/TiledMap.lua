TiledMap = Object:extend()

---------------------
-- Local Functions --
---------------------

local function buildCollisionTable(tile)
    local collision = {}
    -- If there's more than one collision object, this needs to change.
    local object = tile.objectGroup.objects[1]

    collision.shape = object.shape
    collision.offset = {
        x = object.x,
        y = object.y
    }
    collision.vertices = {}

    if object.shape == "rectangle" then
        local x, y, w, h = object.x, object.y, object.width, object.height
        table.insert(collision.vertices, {x,y})
        table.insert(collision.vertices, {x+w, y})
        table.insert(collision.vertices, {x+w, y+h})
        table.insert(collision.vertices, {x, y+h})
    elseif object.shape == "polygon" then
        M.each(object.polygon, function(v)
            table.insert(collision.vertices, {v.x+object.x, v.y+object.y})
        end)
    else
        log.warn("unsupported shape %s", object.shape)
    end

    return collision
end

local function parseGridRange(animation, columns)
    -- Needs to parse columns, ignoring that for now.
    local xrange, yrange = {}, {}

    local continuous = true
    local last
    M.each(animation, function(frame)
        local id = frame.tileid + 1

        if last == nil then last = id - 1 end

        continuous = continuous and id - last <= 1
        last = id

        table.insert(xrange, id)
    end)

    local x,y = nil, 1
    if continuous then
        x = tostring(M.min(xrange)) .. '-' .. tostring(M.max(xrange))
    else
        log.warn('Need to implement non-continuous ranges')
    end

    return x,y
end

-----------------
-- Constructor --
-----------------

function TiledMap:new(room, path)
    self.map = require(path)

    self.tilesets = self.map.tilesets
    for _, tileset in next, self.tilesets do
        tileset.image = love.graphics.newImage('media/'..tileset.image)
    end

    log.info("Parsing tilesets into collisions, animations and classes.")
    local collisions = self:parseTilesets()

    log.info("Building quad tables.")
    self:buildQuads()

    log.info("Loading map.")
    self:load(room, collisions)

    return self
end

---------------------
-- Render Callback --
---------------------

function TiledMap:draw()
    M.each(self.map.layers, function(layer)
        if layer.type == "tilelayer" then
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local tileId = layer.data[(x + y * layer.width) + 1]

                    if tileId ~= 0 then
                        local quad = self.quads[tileId]
                        if quad == nil then return end
                        local _, _, xx, yy = quad.quad:getViewport()
                        xx, yy = xx * x, yy * y

                        if self.animations[tileId] then
                            self.animations[tileId]:draw(quad.image, xx, yy)
                        else
                            love.graphics.draw(quad.image, quad.quad, xx, yy)
                        end
                    end
                end
            end
        end
    end)
end

---------------------
-- Update Callback --
---------------------

function TiledMap:update(dt)
    M.each(self.animations, function(a) 
        a:update(dt) 
    end)
end

-------------------
-- Class Methods --
-------------------

function TiledMap:parseTilesets()
    self.animations, self.classes = {}, {}
    local collisions = {}

    M.each(self.tilesets, function(tileset)
        M.each(tileset.tiles, function(tile)
            local id = tileset.firstgid + tile.id
            if tile.properties and tile.properties.className then
                self.classes[id] = tile.properties.className
            end

            if tile.objectGroup then
                collisions[id] = buildCollisionTable(tile)
            end

            if tile.animation then
                local grid = Anim.newGrid(
                    tileset.tilewidth, tileset.tileheight,
                    tileset.imagewidth, tileset.imageheight
                )

                local x, y = parseGridRange(tile.animation, tileset.columns)
                self.animations[id] = Anim.newAnimation(grid(x,y), tile.animation[1].duration/500)
            end
        end)
    end)

    return collisions
end

function TiledMap:buildQuads()
    self.quads = {}

    M.each(self.tilesets, function(tileset)
        for y = 0, (tileset.imageheight / tileset.tileheight) - 1 do
            for x = 0, (tileset.imagewidth / tileset.tilewidth) - 1 do
                local quad = love.graphics.newQuad(
                    x * tileset.tilewidth,
                    y * tileset.tileheight,
                    tileset.tilewidth,
                    tileset.tileheight,
                    tileset.imagewidth,
                    tileset.imageheight
                )

                table.insert(self.quads, {quad = quad, image = tileset.image})
            end
        end
    end)
end

function TiledMap:load(room, collisions)
    M.each(self.map.layers, function(layer)
        if layer.type == "tilelayer" then
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local tileId = layer.data[(x + y * layer.width) + 1]

                    local collision = collisions[tileId]
                    if collision then
                        local xx = x * self.map.tilewidth
                        local yy = y * self.map.tileheight

                        local transformed = M.map(collision.vertices, function(v)
                            return {
                                v[1] + xx,
                                v[2] + yy,
                            }
                        end)

                        room:polygonColliderFromLines(transformed)
                    end
                end
            end
        elseif layer.type == "objectgroup" then
            M.each(layer.objects, function(obj)
                local id = obj.gid
                local opts = {}

                local quad = self.quads[id]
                opts.image = quad.image
                if self.animations[id] then
                    opts.animation = self.animations[id]
                else
                    opts.quad = quad.quad
                end

                if collisions[id] then
                    opts.collision = collisions[id]
                end

                opts.w, opts.h = obj.width, obj.height
                room:addGameObject(self.classes[id], obj.x+opts.w/2, obj.y+opts.h/2, opts)
            end)
        end
    end)
end

---------------
return TiledMap