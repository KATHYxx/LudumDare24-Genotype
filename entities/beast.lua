--[[
	Beast entity: Creatures that wander, reproduce and spread their genes.
	The Omnicidal gene is recessive, after a certain time period, a oo (false/false) beast will spit fire 
]]

local Class = require "hump.class"
local CollisionCircle = require "entities.collisionCircle"
local consts = require "consts"

local beast = Class(  --constructor
		function(self, location, rgba, allele1, allele2)
			self.body = CollisionCircle(consts.COLRADIUS, location, rgba)
			self.destination = Vector(  --random location to move to 
				location.x + math.random()*consts.DIST_RANGE - consts.DIST_RANGE/2    ,
				location.y + math.random()*consts.DIST_RANGE - consts.DIST_RANGE/2
				)
			self.stepLocat = location -- original location of movement
			self.stepProgress = math.random()  -- [0,1] progress between stepLocat and destination
			
			self.health = consts.BEAST_HEALTH  --basic life
			self.allele1 = allele1
			self.allele2 = allele2
			self.age = 0
			self.ageLastAction = consts.PRE_AGE --this measures a cooloff period between doing something
			self.ageLastFire = consts.PRE_AGE --this measures a cooloff period between doing something
		end
)

function beast:gLocation()
	return self.body.location
end

function beast:sLocation(loc)
	self.body.location = loc
end

function beast:isCarrying()
	return not(self.allele1 and self.allele2)
end

function beast:isOmnicidal()
	return not(self.allele1 or self.allele2)
end

function beast:gRed()
	return self.body.rgba[1]
end
function beast:gGreen()
	return self.body.rgba[2]
end
function beast:gBlue()
	return self.body.rgba[3]
end
function beast:gAlpha()
	return self.body.rgba[4]
end

function beast:ready()
	return ((self.age - self.ageLastAction) > consts.COOLOFF) 
end

function beast:passGene()  --randomly returns one of its alleles, with equal probability
	self.ageLastAction = self.age

	if (math.random() > .5) then
		return self.allele2
	else
		return self.allele1
	end 
end

function beast:collisionTest(otherBeast)
	return self.body:test(otherBeast.body)
end

function beast:collisionWave(waveBody)
	return not(self:isOmnicidal()) and self.body:test(waveBody)
end

function beast:newDestination()
	self.stepLocat = self.body.location  --make the starting point the current point
	self.destination = Vector(           --then choose a random place to go
		self.stepLocat.x + math.random()*consts.DIST_RANGE - consts.DIST_RANGE/2    ,
		self.stepLocat.y + math.random()*consts.DIST_RANGE - consts.DIST_RANGE/2
	)
	-- TODO improve randomness so everyone isn't always on the edges
	self.stepProgress = 0
end

function beast:interpMove()
	--interpolation with Ease Out movement. This moves the location of the creature
	self.body.location = self.stepLocat + ((self.stepProgress^.5) * (self.destination-self.stepLocat))
end

function beast:fireWeapon()  --doesnt actually fire the weapon
	self.ageLastFire = self.age
end
			
function beast:update(dt)  --returns true if a weapon fired
	--movement 
	self.stepProgress = self.stepProgress + dt/consts.SPEED
	if(self.stepProgress >= 1) then
		self:newDestination()
	end
	self:interpMove()
	self.age = self.age + dt

	--omnicide check
	if((not(self.allele1 or self.allele2 ) )  and (self.age > consts.RAGE_AGE)    
	    and ((self.age-self.ageLastFire) > consts.WEAPON_COOL) ) then
		self:fireWeapon()
		return true
	end

	return false
end

function beast:draw()
	if(consts.DEBUG) then
		self.body:draw()
	end
end

return beast








