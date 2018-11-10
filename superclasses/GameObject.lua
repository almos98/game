GameObject = Object:extend()

-----------------
-- Constructor --
-----------------
function GameObject:new(room, x, y, opts)
    local opts = opts or {}
    if opts then for k, v in next, opts do self[k] = v end end

    self.room = room
    self.x, self.y = x, y
    self.dead = false
    self.timer = Timer()

    self.name = self.name or "GameObject"
    self.id = M.uniqueId()

    log.info("Created GameObject with id %d.", self.id)
end

---------------------
-- Update Callback --
---------------------
function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

------------------------
-- Rendering Callback --
------------------------
function GameObject:draw()
    error("Define me please")
end

-------------------
-- Class Methods --
-------------------

function GameObject:__tostring()
    return self.name..self.id
end

-- Checks if an object is a class from the given list.
function GameObject:isA(classList)
    for _, class in next, classList do
        if self:is(_G[class]) then
            return true
        end
    end
    return false
end

function GameObject:destroy()
    self.timer:destroy()
    if self.collider then self.collider:destroy() end
    self.collider = nil
end

-----------------
return GameObject