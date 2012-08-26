--[[
	Game over gamestate.
]]

local consts = require "consts"


local endState = Gamestate.new()

local endSprite = love.graphics.newImage("assets/dead.png")

function endState:init()
end

function endState:update(dt)
end

function endState:draw()
	
	love.graphics.setColor({35,35,35,255})
        love.graphics.draw(BGsprite[1], 0,0)

	

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(endSprite, (consts.SCREEN.x/2), consts.SCREEN.y-650, 1, 3)	
	love.graphics.print("The good beasts have gone extinct", (consts.SCREEN.x/2)-350, 150, 0, 5, 5)
	love.graphics.print("Game over", (consts.SCREEN.x/2)-250, 250, 0, 2, 2)
end

function endState:mousepressed(x, y, button)
	Gamestate.switch(states.start)
end

return endState --allows loading
