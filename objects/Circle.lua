Circle = GameObject:extend()

function Circle:new(area, x, y, opt)
    Circle.super.new(self, area, x, y, opt)
end

function Circle:update(dt)

end

function Circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

-------------
return Circle