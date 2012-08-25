--[[
	Main game action gamestate. Runs the game, pauses, and summons game over
]]

local goState = Gamestate.new()

--libraries
local Col = require "entities.collisionCircle"

local testSphere = Col(25, Vector(300,300), {0,255,0,200}) 

function goState:init()
	
end

function goState:update(dt)
end

function goState:draw()
		testSphere:draw()
end

function goState:mousePressed(x, y, button)
end

return goState --allows loading as a module
