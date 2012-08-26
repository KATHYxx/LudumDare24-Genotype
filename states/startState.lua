--[[
	Gamestate for starting menu
]]

local startState = Gamestate.new()
local consts = require "consts"
local Crosshair = require "entities.crosshair"
local Beast = require "entities.beast"


local beast = Beast(Vector(consts.SCREEN.x/2-50, consts.SCREEN.y/2-50), {255,255,255,255}, true, true)
local crosshair = Crosshair()

function startState:init() -- once
end

function startState:load()
end

function startState:enter()
	beast = Beast(Vector(consts.SCREEN.x/2-50, consts.SCREEN.y/2-50), {255,255,255,255}, true, true)
end

function startState:update(dt)
	crosshair:update(dt)	
	beast:update(dt)
end

function startState:draw()
	love.graphics.setColor({35,35,35,255})
	love.graphics.draw(BGsprite[1], 0,0)

	love.graphics.setColor({255,255,255,255})
	beast:draw()
	
	love.graphics.print("The Omnicide Genotype", 150, 100, 0, 5, 5)
	love.graphics.printf("Several of these hellbeasts have the Omnicide Genotype\n\n"..
		" If they inherit the disease from parents who carry it,"..
		" they will send out waves of death. Destroy all who have the disease AND all who carry the gene. Save the healthy."
		, consts.SCREEN.x/2-250, 500, 500, "center")

	crosshair:draw()
end

function startState:mousepressed(x,y, mouse_btn)
	Gamestate.switch(states.run)  --references globals in main
end

return startState   --allows loading as a module
