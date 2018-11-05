Circle = GameObject:extend()

function Circle:new(area, x, y, opt)
    Circle.super.new(self, area, x, y, opt)
    self.room.world:newCircleCollider(self.x, self.y, self.radius)
end

function Circle:update(dt)

end

function Circle:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

-------------
return Circle