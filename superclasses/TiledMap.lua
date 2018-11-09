TiledMap = Object:extend()

---------------------
-- Local Functions --
---------------------

local function insertVertex(t, x, y)
    table.insert(t, x)
    table.insert(t, y)
end

local function parseCollisionTables(tiles)
    local collisions = {}

    M.each(tiles, function(tile)
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
            
        else
            debug(("unsupported shape %s"):format(object.shape))
            return
        end

        collision[tile.id+1] = t
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

local function buildCollisions(room, map, collisionTables)
    M.each(map.layers, function(layer)
        
    end)
end

-----------------
-- Constructor --
-----------------

function TiledMap:new(room, path)
    self.map = require(path)

    self.tileset = self.map.tilesets[1]
    self.image = love.graphics.newImage('media/'..self.tileset.image)

    local collisionTables = parseCollisionTables(self.tileset.tiles)
    self.quads = buildQuadsTable(self.tileset)
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