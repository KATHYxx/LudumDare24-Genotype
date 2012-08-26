--[[
	Game over gamestate.
]]

local consts = require "consts"


local endState = Gamestate.new()

function endState:init()
end

function endState:update(dt)
end

function endState:draw()
	love.graphics.print("Obidient Beasts Extinct", consts.SCREEN.x/2-350, 250, 0, 5, 5)
end

function endState:mousepressed(x, y, button)
	Gamestate.switch(states.start)
end

return endState --allows loading
