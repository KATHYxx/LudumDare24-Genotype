--[[ 
	Death wave (a fireball eque weapon) 
]]

local Class = require "hump.class"
local CollisionCircle = require "entities.collisionCircle"
local consts = require "consts"

local deathWave = Class ( --constructor needs originating location
		function(self, location)  
			self.body = CollisionCircle(consts.DEATH_RADIUS, location, consts.DEATH_COLOR)
			self.eye = CollisionCircle(consts.EYE_RADIUS, location, consts.EYE_COLOR)
			self.age = 0
		end
)

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
	if(consts.DEBUG) then
		self.body:draw()
		self.eye:draw()
	end
end

return deathWave
