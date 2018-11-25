Room = Object:extend()

local graphics = love.graphics
-----------------
-- Constructor --
-----------------
function Room:new(canvasDimensions)
    local canvasDimensions = canvasDimensions or M.pack(gw, gh)

    self.name = "Room"

    self.gameObjects = {}
    self.mainCanvas = graphics.newCanvas(unpack(canvasDimensions))

    log.info("Superclass %s initialised.", self)
end

---------------------
-- Update Callback --
---------------------
function Room:update(dt)
    if self.world then self.world:update(dt) end

    if self.map then self.map:update(dt) end
    for i = #self.gameObjects, 1, -1 do
        local gameObject = self.gameObjects[i]
        gameObject:update(dt)
        if gameObject.dead then
            gameObject:destroy()
            table.remove(self.gameObjects, i)
            log.info("Removing dead object %s", gameObject)
        end
    end
end

------------------------
-- Rendering Callback --
------------------------
function Room:draw()
    graphics.setCanvas(self.mainCanvas)
    graphics.clear()

    camera:attach(0, 0, gw, gh)
    if self.map then self.map:draw() end
    self.gameObjects = M.sort(self.gameObjects, function(a,b)
        return a.y < b.y
    end)
    M.each(self.gameObjects, function(o)
        o:draw()
    end)
    if debugging then self.world:draw() end

    camera:detach()
    camera:draw()

    graphics.setCanvas()

    graphics.setColor(1, 1, 1, 1)
    graphics.setBlendMode('alpha', 'premultiplied')
    graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    graphics.setBlendMode('alpha')
end

-------------------
-- Class Methods --
-------------------

function Room:__tostring()
    return self.name
end

function Room:addPhysicsWorld()
    self.world = Physics.newWorld(0,0,true)
    log.info("Created new physics world for room %s", self)
end

function Room:polygonColliderFromLines(vertices, collisionType)
    local collisionType = collisionType or 'static'
    local first = vertices[1]
    local last  = vertices[#vertices]
    M.each(vertices, function(v,i)
        local vNext = v == last and first or vertices[i+1]
        self.world:newLineCollider(v[1],v[2], vNext[1],vNext[2]):setType(collisionType)
    end)
end

function Room:setMap(path)
    self.map = TiledMap:new(self, path)
    log.info("Loaded new map from '%s' to room %s", path, self)
end

function Room:destroy()
    for i = #self.gameObjects, 1, -1 do
        local gameObject = self.gameObjects[i]
        gameObject:destroy()
        table.remove(self.gameObjects, i)
    end
    self.gameObjects = {}

    if self.world then
        self.world:destroy()
        self.world = nil
    end

    log.info("Room %s cleaned up", self)
end

function Room:addGameObject(gameObjectType, x, y, opts)
    local opts = opts or {}
    local gameObject = _G[gameObjectType](self, x, y, opts)
    table.insert(self.gameObjects, gameObject)

    log.info("Added new GameObject %s to room %s", gameObject, self)
    return gameObject
end

function Room:getGameObjects(fn)
    if fn then
        return M.select(self.gameObjects, fn)
    end
    
    return self.gameObjects
end

function Room:queryCircleArea(x, y, radius, classes)
    local classes = classes or {}
    return M.select(self.gameObjects, function(o)
        return (util.distance(x, y, o.x, o.y) <= radius) and (o:isA(classes))
    end)
end

function Room:getClosestGameObject(x, y, radius, classes)
    local classes = classes or {}
    local radius = radius or math.huge
    local closest, dist = nil, math.huge

    M.each(self.gameObjects, function(o)
        local d = util.distance(x, y, o.x, o.y)
        if d <= radius and o:isA(classes) and d < dist then
            closest = o
            dist = d
        end
    end)

    return closest
end

-----------------
return Room
