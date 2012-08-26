--[[
	Main game action gamestate. Runs the game, pauses, and summons game over
]]

local goState = Gamestate.new()

--libraries
local BeastSchool = require "entities.beastSchool"
local LiveAmmo = require "entities.liveAmmo"
local Crosshair = require "entities.crosshair"
local Hud = require "entities.hud"
local consts = require "consts"

--game entities
local school = BeastSchool()
local ammo = LiveAmmo()
local crosshair = Crosshair()
local hud = Hud()

local startingSize = 3 
local startingCarrying = 1 
local actualStartingSpeed = consts.SPEED
local flash = false

function goState:init()
	math.randomseed(os.time())
	--local moo = 1/7 
	--print (""..moo)


end

function goState:enter(prevState)
	school:reset()
	school:initGenerationZero(startingSize, startingCarrying)
	ammo:reset()
	startingSize = consts.STARTING_BEASTS
	startingCarrying = consts.STARTING_CARRIERS
	hud:startNewGame()
	consts.SPEED = actualStartingSpeed

	Sound:playConfirm()
end

function goState:startNewLevel()
	startingSize = (hud.batch % 7) + 2 
	startingCarrying = math.floor(hud.batch / 7) + 1
	consts.SPEED = consts.SPEED - .1

	hud:startNewLevel(startingCarrying, startingSize)
	hud.isGametime = true

	ammo:reset()
	school:reset()
	school:initGenerationZero(startingSize, startingCarrying)

	Sound:playTick()
end

function goState:removeBeast(index)
	table.remove(school.school, index)
end

function goState:updateGame(dt) --update when the game is not paused or between levels
	school:update(dt)
	ammo:addWave(school:gNewAttack())
	ammo:update(dt)


	--death, population checks
	local deathMark = -1
	hud.population = #school.school 
	hud.carriers = 0
	for j=1, #school.school do
		if(school.school[j]:isCarrying()) then
			hud.carriers = hud.carriers + 1
		end	
		if(ammo:checkHit(school.school[j])) then
			deathMark = j
		end
	end
	if(deathMark > 0) then
		self:removeBeast(deathMark)
		Sound:playSad()
	end

	if(hud.carriers == 0 and hud.population > 0) then
		hud:endLevel() --isGametime to false
	elseif(hud.carriers == hud.population) then
		Gamestate.switch(states.over)
	end	

end

function goState:updateEndLevel(dt)
	--school:update(dt)
	if(hud.modeAge >= 6) then
		hud.isGametime = true
		goState:startNewLevel()
	end
end

function goState:update(dt)
	if(not hud.isPaused) then
		--[[if(hud.population == hud.carriers and hud.carriers > 0) then                  -- game over
			Gamestate.switch(states.over)
		elseif(hud.population == 0) then
			Gamestate.switch(states.over)
		elseif((hud.carriers == 0) and (not(hud.isGametime))) then   --end the level and display the score screen
			goState:updateEndLevel(dt)
		elseif(hud.carriers == 0 and hud.isGametime) then        --start the next level
			goState:startNewLevel()
		else                                                     -- play the game
			goState:updateGame(dt)
		end]]
		
		if(hud.isGametime == true) then
			goState:updateGame(dt)
		elseif(hud.isGametime == false) then
			goState:updateEndLevel(dt)
		end
	end
	
	hud:update(dt)
	crosshair:update(dt)	
end

function goState:draw()
	love.graphics.setColor({85,85,85,255})

	--background drawn first
	love.graphics.draw(BGsprite[1], 0, 0)
	love.graphics.setColor({95,95,95,255})
	love.graphics.draw(BGsprite[2], 0, 0)
	
	if(not hud.isPaused) then
		school:draw()
		ammo:draw()
	end

	if(flash == true) then
		love.graphics.setColor(255,255,255,200)
		love.graphics.rectangle("fill", 0,0, consts.SCREEN.x, consts.SCREEN.y)
		flash = false
		love.graphics.setColor(255,255,255,255)
	end

	crosshair:draw()
	hud:draw()
	
end

function goState:mousepressed(x, y, button)
	local target = -1
	crosshair:fire()

	if(not hud.isPaused and hud.isGametime) then
		crosshair:update(0)
		for i=1, #school.school do
			if (crosshair:testBeast(school.school[i])) then
				target = i
				break
			end
		end
	end
	
	if(target > 0) then
		hud.score = hud.score + 1
		hud.killedThisLevel = hud.killedThisLevel + 1
		self:removeBeast(target)
		Sound:playHit()
		Sound:playSad()
		flash = true
	end
end

function goState:keypressed(key)
	hud:togglePause()	
end

return goState --allows loading as a module






