Player = GameObject:extend()

function Player:new(room, x, y, opt)
    Player.super.new(self, room, x, y, opt)

    if not self.controller then
        self.controller = input
    end
    
    self.sheet = love.graphics.newImage('media/spritesheet.png')
    self.g = Anim.newGrid(23,23, 121,25, 0,0, 1)
    self.Animations = {
        idle = Anim.newAnimation(self.g(1,1),2),
        walking = Anim.newAnimation(self.g('2-4', 1), 0.1),
    }

    self.status = 'idle'
    self.speed = 100
    self.direction = 1

    self.w = 25
    self.controller:bind('a', 'left')
    self.controller:bind('s', 'down')
    self.controller:bind('d', 'right')
    self.controller:bind('w', 'up')

    self.collider = self.room.world:newRectangleCollider(self.x, self.y+self.w/2, self.w, self.w/4)
    self.collider:setObject(self) 
    self.collider:setType('dynamic')
    self.collider:setFixedRotation(true)
end

function Player:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
    self.y = self.y - self.w/4

    local dx, dy = 0,0
    if self.controller:down('left') then dx = -self.speed end
    if self.controller:down('down') then dy = self.speed end
    if self.controller:down('right') then dx = self.speed end
    if self.controller:down('up') then dy = -self.speed end

    if (dx==0 and dy==0) then
        self.status = 'idle'
        self:setVelocity(0,0)
    else
        self:walk(dx,dy)
    end

    self.currentAnimation = self.Animations[self.status]
    self.currentAnimation:update(dt)
end

function Player:draw()
    self.currentAnimation:draw(self.sheet, self.x-self.w/2, self.y-self.w/2)
    --love.graphics.rectangle('line', self.x-self.w/2, self.y-self.w/2, self.w, self.w)
end

function Player:walk(dx, dy)
    local direction = dx > 0 and 1 or dx < 0 and -1 or self.direction
    if self.direction ~= direction then self:flipAnimations() end
    
    self.status = 'walking'
    self:setVelocity(dx,dy)
end

function Player:flipAnimations()
    self.direction = -self.direction
    M.each(self.Animations, function(o)
        o:flipH()
    end)
end

function Player:setVelocity(x,y)
    self.collider:setLinearVelocity(x,y)
end

-------------
return Player