TiledMap = Object:extend()

---------------------
-- Local Functions --
---------------------

local function insertVertex(t, x, y)
    table.insert(t, {x,y})
end

local function collisionTable(tile)
    local collision = {}
    local object = tile.objectGroup.objects[1]

    collision.shape = object.shape
    collision.offset = {
        x = object.x, y = object.y
    }
    collision.vertices = {}

    if object.shape == "rectangle" then
        local x, y, w, h = object.x, object.y, object.width, object.height
        insertVertex(collision.vertices, x, y)
        insertVertex(collision.vertices, x+w, y)
        insertVertex(collision.vertices, x+w, y+h)
        insertVertex(collision.vertices, x, y+h)
    elseif object.shape == "polygon" then
        M.each(object.polygon, function(v,i)
            insertVertex(collision.vertices, v.x+object.x, v.y+object.y)
        end)
    else
        log.warn("unsupported shape %s", object.shape)
        return
    end

    log.info("Collision box of shape %s with vertices:\n%s", collision.shape, util.toString(collision.vertices))
    return collision
end

local function parseTables(tilesets)
    local collisions = {}

    M.each(tilesets, function(ts)
        M.each(ts.tiles, function(tile,i)
            log.debug(util.toString(tile))

            if tile.objectGroup then
                collisions[tile.id+1] = collisionTable(tile)
            end
        end)
    end)

    return collisions
end

local function buildQuadsTable(tilesets)
    local quads = {}

    M.each(tilesets, function(tileset)
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
                table.insert(quads, {quad = quad, image=tileset.image})
            end
        end
    end)

    return quads
end

local function polygonFromLines(world, vertices)
    local first = vertices[1]
    local last = vertices[#vertices]
    M.each(vertices, function(v,i)
        local nextV = v == last and first or vertices[i+1]
        world:newLineCollider(v[1],v[2],nextV[1],nextV[2]):setType('static')
        log.debug('Line collider from (%d, %d) to (%d, %d)', v[1], v[2], nextV[1], nextV[2])
    end)
end

local function buildCollisions(room, map, collisionTables)
    M.each(map.layers, function(layer, i)
        if layer.type == "tilelayer" then
            for y = 0, layer.height - 1 do
                for x = 0, layer.width - 1 do
                    local index = (x + y * layer.width) + 1
                    local tileId = layer.data[index]
                    local collision = collisionTables[tileId]

                    if collision ~= nil then
                        local xx = x * map.tilewidth
                        local yy = y * map.tileheight

                        local transformed = M.map(collision.vertices, function(v)
                            t = {
                                v[1] + xx,
                                v[2] + yy,
                            }
                            
                            return t
                        end)
                        
                        polygonFromLines(room.world, transformed)
                    end
                end
            end
        end
    end)
end

-----------------
-- Constructor --
-----------------

function TiledMap:new(room, path)
    self.map = require(path)

    self.tilesets = self.map.tilesets
    M.each(self.tilesets, function(ts)
        ts.image = love.graphics.newImage('media/'..ts.image)
    end)

    log.info("Building collision and animation tables.")
    local collisions, animations = parseTables(self.tilesets)

    log.info("Building quad tables.")
    self.quads = buildQuadsTable(self.tilesets)

    log.info("Building collisions from map.")
    buildCollisions(room, self.map, collisions)

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
                    local index = (x + y * layer.width) + 1
                    local tileId = layer.data[index]

                    if tileId ~= 0 then
                        local quad = self.quads[tileId]
                        local _, _, xx, yy = quad.quad:getViewport()
                        xx, yy = xx * x, yy * y
                        love.graphics.draw(quad.image, quad.quad, xx, yy )
                    end
                end
            end
        elseif layer.type == "objectgroup" then
            M.each(layer.objects, function(obj)
                local quad = self.quads[obj.gid+1]
                local xx, yy = obj.x, obj.y
                love.graphics.draw(quad.image, quad.quad, xx, yy)
            end)
        end
    end)
end

---------------
return TiledMap
