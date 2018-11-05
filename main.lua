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

local currentRoom

------------------
-- Game Loading --
------------------

function love.load(args)
    -- Loading Rooms and Objects
    util.requireFiles(util.recursiveEnumerate('objects'))
    util.requireFiles(util.recursiveEnumerate('rooms'))

    input   = Input()
    timer   = Timer()
    camera  = Camera()
end

---------------------
-- Update Callback --
---------------------
function love.update(dt)
    timer:update(dt)
    camera:update(dt)

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