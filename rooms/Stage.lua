Stage = Room:extend()

function Stage:new()
    Stage.super.new(self)

    self:addPhysicsWorld()

    self:addGameObject('Player', gw/2, gh/2)
    for i = 1, 1000 do
        self:addGameObject('Box', love.math.random(-1000, 1000), love.math.random(-1000,1000), {tw=50, th=20, z=5})
    end
end

------------
return Stage