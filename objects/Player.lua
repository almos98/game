Player = GameObject:extend()

function Player:new(room, x, y, opt)
    Player.super.new(self, room, x, y, opt)

    if not self.controller then
        self.controller = input
    end
    
    self.w = 12
    self.controller:bind('a', 'left')
    self.controller:bind('left', 'left')
    self.controller:bind('d', 'right')
    self.controller:bind('right', 'right')
end

function Player:update(dt)
    if self.controller:down('left') then self.x = self.x - 500 * dt end
    if self.controller:down('right') then self.x = self.x + 500 * dt end
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
end

-------------
return Player