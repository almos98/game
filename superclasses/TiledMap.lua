TiledMap = Object:extend()

---------------------
-- Local Functions --
---------------------

local function insertVertex(t, x, y)
    table.insert(t, {x,y})
end

local function parseCollisionTables(tiles)
    local collisions = {}

    M.each(tiles, function(tile,i)
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

        log.debug("Collision box of shape %s with vertices:\n%s", collision.shape, util.toString(collision.vertices))
        collisions[tile.id+1] = collision
    end)

    return collisions
end

local function buildQuadsTable(tileset)
    local quads = {}

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
            table.insert(quads, quad)
        end
    end

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
    end)
end

-----------------
-- Constructor --
-----------------

function TiledMap:new(room, path)
    self.map = require(path)

    self.tileset = self.map.tilesets[1]
    self.image = love.graphics.newImage('media/'..self.tileset.image)

    log.info("Building collision tables.")
    local collisionTables = parseCollisionTables(self.tileset.tiles)

    log.info("Building quad tables.")
    self.quads = buildQuadsTable(self.tileset)

    log.info("Building collisions from map.")
    buildCollisions(room, self.map, collisionTables)

    return self
end

---------------------
-- Render Callback --
---------------------

function TiledMap:draw()
    M.each(self.map.layers, function(layer)
        for y = 0, layer.height - 1 do
            for x = 0, layer.width - 1 do
                local index = (x + y * layer.width) + 1
                local tileId = layer.data[index]

                if tileId ~= 0 then
                    local quad = self.quads[tileId]
                    local xx = x * self.tileset.tilewidth
                    local yy = y * self.tileset.tileheight
                    love.graphics.draw(self.image, quad, xx, yy )
                end
            end
        end
    end)
end

---------------
return TiledMap