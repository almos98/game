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
log     = require 'libraries/log'

local currentRoom

local debug_levels = {"trace", "debug", "info", "warn", "error", "fatal"}

------------------
-- Game Loading --
------------------

function love.load(args)
    local dLevel = 4
    if args[1] == "-d" then
        debugging = true
        dLevel = tonumber(args[2]) or 2
    end
    log.level = debug_levels[dLevel]

    util.requireFiles(util.recursiveEnumerate('superclasses'))
    util.requireFiles(util.recursiveEnumerate('objects'))
    util.requireFiles(util.recursiveEnumerate('rooms'))

    log.info("Loaded game files okay.")

    love.graphics.setDefaultFilter('nearest')
    love.graphics.setLineStyle('rough')
    resize(3)

    love.physics.setMeter(32)

    log.info("Pixelized.")

    input   = Input()
    timer   = Timer()

    camera  = Camera(200, 150, 400, 300)
    camera:setFollowStyle("TOPDOWN_TIGHT")
    camera:setFollowLerp(0.2)
    camera:setFollowLead(10)

    log.info("Camera loaded")
    log.info("Loading game")

    gotoRoom('Stage')
    player = currentRoom:getGameObjects(function(o) return o:is(Player) end)[1]

    log.info("%s", {test=12})
    log.info("Game loaded")
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

    log.trace("Game updated with delta time of %f.", dt)
end

------------------------
-- Rendering Callback --
------------------------
local frameCount = 0

function love.draw()
    if currentRoom then
        currentRoom:draw()
    end

    log.trace("Game frame %d rendered.", frameCount)
    frameCount = frameCount + 1

    -- Possibly never going to be called.
    if frameCount < 0 then
        log.warn("Frame count overflow.")
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
    log.info("Changed render scale to %d.", s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end
