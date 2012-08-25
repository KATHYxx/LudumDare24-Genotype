--[[
	Main game action gamestate. Runs the game, pauses, and summons game over
]]

local goState = Gamestate.new()

--libraries
local BeastSchool = require "entities.beastSchool"
local LiveAmmo = require "entities.liveAmmo"

local school = BeastSchool()
local ammo = LiveAmmo()
local startingSize = 6 
local startingCarrying = 2 

function goState:init()
	math.randomseed(os.time())	
end

function goState:enter(prevState)
	school:initGenerationZero(startingSize, startingCarrying)
	ammo:reset()
end

function goState:update(dt)
	school:update(dt)
	ammo:addWave(school:gNewAttack())
	ammo:update(dt)
end

function goState:draw()
	love.graphics.setColor({255,255,255,255})
	school:draw()
	ammo:draw()
end

function goState:mousePressed(x, y, button)
end

return goState --allows loading as a module
