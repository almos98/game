Box = GameObject:extend()

function Box:new(room, x, y, opt)
    Box.super.new(self, room, x, y, opt)

    self.a = self.z*math.asin(math.pi/4)
    self.w = self.tw-self.a
    self.h = self.th-self.a

    local p1x,p1y = self.x-self.tw/2, self.y+self.th/2
    local p2x,p2y = p1x+self.w,p1y
    local p3x,p3y = self.x+self.tw/2, self.y+self.th/2-self.a
    local p4x,p4y = p1x,p3y

    self.collider = self.room.world:newPolygonCollider({p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y})
    self.collider:setType('static')
end

function Box:update(dt)

end

function Box:draw()
    local woff, hoff = self.tw/2, self.th/2

    local p1x, p1y = self.x-woff, self.y-hoff+self.a
    local p2x, p2y = self.x-woff, self.y+hoff
    local p3x, p3y = self.x+woff-self.a, self.y+hoff
    local p4x, p4y = self.x+woff-self.a, self.y-hoff+self.a
    local p5x, p5y = self.x+woff, self.y+hoff-self.a
    local p6x, p6y = self.x+woff, self.y-hoff
    local p7x, p7y = self.x-woff+self.a, self.y-hoff
    
    love.graphics.line(p1x,p1y,p2x,p2y)
    love.graphics.line(p2x,p2y,p3x,p3y)
    love.graphics.line(p3x,p3y,p4x,p4y)
    love.graphics.line(p4x,p4y,p1x,p1y)
    love.graphics.line(p3x,p3y,p5x,p5y)
    love.graphics.line(p4x,p4y,p6x,p6y)
    love.graphics.line(p1x,p1y,p7x,p7y)
    love.graphics.line(p5x,p5y,p6x,p6y)
    love.graphics.line(p7x,p7y,p6x,p6y)
end
----------
return Box