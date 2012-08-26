--[[
	Gamestate for starting menu
]]

local startState = Gamestate.new()
local consts = require "consts"
local Crosshair = require "entities.crosshair"
local Beast = require "entities.beast"
local BeastSchool = require "entities.beastSchool"

local beast = Beast(Vector(consts.SCREEN.x/2-50, consts.SCREEN.y/2-50), {255,255,255,255}, true, true)
local school = BeastSchool()
table.insert(school.school, beast)

local crosshair = Crosshair()

function startState:init() -- once
end

function startState:load()
end

function startState:enter()
	beast = Beast(Vector(consts.SCREEN.x/2-50, consts.SCREEN.y/2-50), {255,255,255,255}, true, true)
	school:reset()
	table.insert(school.school, beast)
end

function startState:update(dt)
	crosshair:update(dt)	
	school:update(dt)
end

function startState:draw()
	love.graphics.setColor({35,35,35,255})
	love.graphics.draw(BGsprite[1], 0,0)

	love.graphics.setColor({255,255,255,255})
	school:draw()
	
	love.graphics.print("The Omnicide Genotype", 150, 100, 0, 5, 5)
	love.graphics.printf("Several of these hellbeasts have the Omnicide Genotype\n\n"..
		" If they have the disease, they will send out waves of death and destruction,"..
		" Other beasts carry the genotype without suffering its effects, but they pass it on to their children who can have the disease "..
		"\n Destroy all who have the disease AND all who carry the gene. Save the healthy."
		, consts.SCREEN.x/2-250, 500, 500, "center")

	crosshair:draw()
end

function startState:mousepressed(x,y, mouse_btn)
	Gamestate.switch(states.run)  --references globals in main
end

return startState   --allows loading as a module
