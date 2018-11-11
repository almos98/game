Campfire = GameObject:extend()

function Campfire:new(room, x, y, opt)
    Campfire.super.new(self, room, x, y, opt)

    -- These colliders don't trigger any events
    if self.collision then
        local transformed = M.map(self.collision.vertices, function(v)
            return {
                v[1] + self.x-self.w/2,
                v[2] + self.y-self.h/2,
            }
        end)

        room:polygonColliderFromLines(transformed)
    end
end

function Campfire:draw()
    if self.animation then
        self.animation:draw(self.image, self.x-self.w/2, self.y-self.h/2)
    end
end

function Campfire:update(dt)
    if self.animation then
        self.animation:update(dt)
    end
end

---------------
return Campfire