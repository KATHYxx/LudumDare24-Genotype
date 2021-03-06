--[[ 
Genotype (Working Title)
by Katherine Blizard

Ludum Dare 24 

--Main.lua. Required starting point for all Love 2D games. 
--Here, the game will split into its distinct gamestates.
]]


--Globals
Gamestate = require "hump.gamestate"
Camera = require "hump.camera"
Vector = require "hump.vector"

Sounds = require "entities.sound"
Sound = Sounds()

BGsprite = {
        love.graphics.newImage("assets/bg.png"),
        love.graphics.newImage("assets/bg0.png")
}


--load Gamestates
states = {}
states.start = require "states.startState"
states.run = require "states.goState"
states.over = require "states.endState" 

function love.load()
	-- entry point into game. Immediately hand off the game to the beginning gamestate
	Gamestate.registerEvents()
	Gamestate.switch(states.start) 
end


