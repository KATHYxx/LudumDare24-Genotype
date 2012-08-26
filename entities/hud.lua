--[[ 
	For drawing letters on the screen.
	Also keeps track of the text time flow, game score, and the space between levels
]]

local Class = require "hump.class"
local consts = require "consts"

local hud = Class(
		function(self)
			self.isPaused = false      --tracks pause mode
			self.isGametime = true    --false: showing end of level score. true: showing game HUD

			--per game stats
			self.score = 0
			self.batch = 1  --level names
			
			--per level stats
			self.carriers = consts.STARTING_CARRIERS
			self.population = consts.STARTING_BEASTS
			self.killedThisLevel = 0
			self.diedThisLevel = 0
			
			self.modeAge = 0    --keeps track of how much time (in seconds) goes by
		end
)

function hud:togglePause()
	self.isPaused = not self.isPaused
end


function hud:startNewLevel(nextCarry, nextPop)
	self.carriers = nextCarry
	self.population = nextPop
	self.killedThisLevel = 0
	self.diedThisLevel = 0
	self.batch = self.batch + 1
	self.modeAge = 0
end

function hud:startNewGame()
	self.isPaused = false      --tracks pause mode
	self.isGametime = true    --false: showing end of level score. true: showing game HUD

	--per game stats
	self.score = 0
	self.batch = 1  --level names
	
	--per level stats
	self.carriers = consts.STARTING_CARRIERS
	self.population = consts.STARTING_BEASTS
	self.killedThisLevel = 0
	self.diedThisLevel = 0
	
	self.modeAge = 0  
end

function hud:endLevel()
	self.isGametime = false
	self.modeAge = 0
	self.score = self.score + self.population*10
end

function hud:update(dt)
	self.modeAge = self.modeAge + dt
end

function hud:drawEndLevel()
	love.graphics.print("Level Completed! ", consts.SCREEN.x/2-300, 50, 0, 7, 7)

	if(self.modeAge > 1) then
		love.graphics.print("Killed this level: ".. self.killedThisLevel, consts.SCREEN.x/2-200, 150, 0, 2, 2 )
	end
	if(self.modeAge > 2) then
		love.graphics.print("Saved: ".. self.population, consts.SCREEN.x/2-100, 200, 0, 2, 2 )
	end
	if(self.modeAge > 3) then
		love.graphics.print("Score: ".. self.score, consts.SCREEN.x/2-50, 250, 0, 2, 2 )
	end

	if(self.modeAge > 1.0 and self.modeAge < 1.1) then
		Sound:playWin(1)
	elseif(self.modeAge > 1.0 and self.modeAge < 1.1) then
		Sound:playWin(2)
	elseif(self.modeAge > 1.0 and self.modeAge < 1.1) then
		Sound:playWin(3)
	end

end

function hud:drawStartLevel()
	if(self.modeAge < 2.5) then
		love.graphics.print("Batch " .. self.batch, consts.SCREEN.x/2-150, 250, 0, 5, 5)
	end
end

function hud:drawGametime()
	self:drawStartLevel()
	love.graphics.print("Population: " .. self.population, 10, 10, 0, 2,2)	
	love.graphics.print("Carriers: " .. self.carriers, 10, 40, 0, 2, 2)
	love.graphics.print("Score: " .. self.score, 10, 70, 0, 2, 2)
end


function hud:drawPaused()
	love.graphics.print("Paused", consts.SCREEN.x/2, consts.SCREEN.y/2, -32, 7, 7)
	self:drawGametime()
end

function hud:draw()
	if(self.isPaused == true) then                                   --paused
		self:drawPaused()
	end
	
	if(self.isGametime == false) then
		self:drawEndLevel()
	elseif(self.isGametime == true) then
		self:drawGametime()
	end
end
return hud
