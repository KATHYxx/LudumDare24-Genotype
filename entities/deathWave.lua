--[[ 
	Death wave (a fireball eque weapon) 
]]

local Class = require "hump.class"
local CollisionCircle = require "entities.collisionCircle"
local consts = require "consts"

local waveSprite = love.graphics.newImage("assets/wave1.png")
local eyeSprite = love.graphics.newImage("assets/wave2.png")
local xOffD = waveSprite:getWidth()/2
local yOffD = waveSprite:getHeight()/2
local xOffE = eyeSprite:getWidth()/2
local yOffE = eyeSprite:getHeight()/2

local deathWave = Class ( --constructor needs originating location
		function(self, location)  
			self.body = CollisionCircle(consts.DEATH_RADIUS, location, consts.DEATH_COLOR)
			self.eye = CollisionCircle(consts.EYE_RADIUS, location, consts.EYE_COLOR)
			self.age = 0
		end
)

function deathWave:radiusLerpD(d)
	return consts.SPRITE_MIN_D + (d)*((consts.SPRITE_MAX_D-consts.SPRITE_MIN_D)/consts.WAVE_FADE)
end

function deathWave:radiusLerpE(d)
	return consts.SPRITE_MIN_E + (d)*((consts.SPRITE_MAX_E-consts.SPRITE_MIN_E)/consts.WAVE_FADE)
end

function deathWave:update(dt)
	self.age = self.age + dt
	local deltaTime = self.age^.5   --modify this line to change types of interpolation

	--outer wave
	self.body.radius = consts.DEATH_RADIUS + (deltaTime)*((consts.DEATH_MAX_RADIUS-consts.DEATH_RADIUS)/(consts.WAVE_FADE))
	--eye of wave	
	self.eye.radius = consts.EYE_RADIUS + (deltaTime)*((consts.EYE_MAX_RADIUS-consts.EYE_RADIUS)/(consts.WAVE_FADE))

	return self.age > consts.WAVE_FADE --return true if the wave is over and it needs to die
end

function deathWave:draw()
	--if(consts.DEBUG) then
		self.body:draw()
		self.eye:draw()
	--end

	--[[local scaleD = self:radiusLerpD(self.age^.5)
	local scaleE = self:radiusLerpE(self.age^.5)
	love.graphics.draw(waveSprite, self.body.location.x-(xOffD/2), self.body.location.y-(yOffD/2), 0, scaleD, scaleD)
	love.graphics.draw(eyeSprite, self.body.location.x-(xOffE/2), self.body.location.y-(yOffE/2), 0, scaleE, scaleE)
	]]
end

return deathWave
