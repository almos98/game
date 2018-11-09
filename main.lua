------------------------------------------
-- Library Loading and Global Variables --
------------------------------------------

Object  = require 'libraries/classic'
util    = require 'libraries/util'
Input   = require 'libraries/Input'
Timer   = require 'libraries/EnhancedTimer'
M       = require 'libraries/moses'
Camera  = require 'libraries/Camera'
Physics = require 'libraries/windfield'
Anim    = require 'libraries/anim8'

local currentRoom

------------------
-- Game Loading --
------------------

function love.load(args)
    util.requireFiles(util.recursiveEnumerate('superclasses'))
    util.requireFiles(util.recursiveEnumerate('objects'))
    util.requireFiles(util.recursiveEnumerate('rooms'))

    love.graphics.setDefaultFilter('nearest')
    love.graphics.setLineStyle('rough')
    resize(3)

    love.physics.setMeter(32)

    input   = Input()
    timer   = Timer()

    camera  = Camera(200, 150, 400, 300)
    camera:setFollowStyle("TOPDOWN_TIGHT")
    camera:setFollowLerp(0.2)
    camera:setFollowLead(10)

    gotoRoom('Stage')
    player = currentRoom:getGameObjects(function(o) return o:is(Player) end)[1]
end

---------------------
-- Update Callback --
---------------------
function love.update(dt)
    timer:update(dt)
    camera:update(dt)
    
    camera:follow(player.x, player.y)
    if currentRoom then
        currentRoom:update(dt)
    end
end

------------------------
-- Rendering Callback --
------------------------
function love.draw()
    if currentRoom then
        currentRoom:draw()
    end
end

--------------------
-- Game Functions --
--------------------
-- Change current room
function gotoRoom(roomType, ...)
    if currentRoom then currentRoom:destroy() end
    currentRoom = _G[roomType](...)
end

-- Resize game window
function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end
