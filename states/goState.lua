--[[
	Main game action gamestate. Runs the game, pauses, and summons game over
]]

local goState = Gamestate.new()

--libraries
local BeastSchool = require "entities.beastSchool"

local school = BeastSchool()
local startingSize = 5
local startingCarrying = 2

function goState:init()
	
end

function goState:enter(prevState)
	school:initGenerationZero(startingSize, startingCarrying)
end

function goState:update(dt)
	school:update(dt)
end

function goState:draw()
	love.graphics.setColor({255,255,255,255})
	school:draw()
end

function goState:mousePressed(x, y, button)
end

return goState --allows loading as a module
