--[[
	Beast entity: Creatures that wander, reproduce and spread their genes.
	The Omnicidal gene is recessive, after a certain time period, a oo (false/false) beast will spit fire 
]]

local Class = require "hump.class"
local CollisionCircle = require "entities.collisionCircle"
local consts = require "consts"

local leftSprite = {
	love.graphics.newImage("assets/beastsprite/left1.png"),
	love.graphics.newImage("assets/beastsprite/left2.png"),
	love.graphics.newImage("assets/beastsprite/left3.png"),
	love.graphics.newImage("assets/beastsprite/left4.png"),
	love.graphics.newImage("assets/beastsprite/left5.png"),
	love.graphics.newImage("assets/beastsprite/left6.png"),
	love.graphics.newImage("assets/beastsprite/left7.png")
}

local downSprite = {
	love.graphics.newImage("assets/beastsprite/down1.png"),
	love.graphics.newImage("assets/beastsprite/down2.png"),
	love.graphics.newImage("assets/beastsprite/down3.png"),
	love.graphics.newImage("assets/beastsprite/down4.png"),
	love.graphics.newImage("assets/beastsprite/down5.png")
}

local upSprite = {
	love.graphics.newImage("assets/beastsprite/Up1.png"),
	love.graphics.newImage("assets/beastsprite/Up2.png"),
	love.graphics.newImage("assets/beastsprite/Up3.png"),
	love.graphics.newImage("assets/beastsprite/Up4.png")
}

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

function beast:horny()
	return ((self.age - self.ageLastAction) > consts.LONELY_AGE)
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

function beast:assignCarrier()
	if(math.random() > .5) then
		self.allele1 = false
	else
		self.allele2 = false
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
	self.stepProgress = 0
end

function beast:setDestination(destination)  --as above, but this time with a specific location in mind
	self.stepLocat = self.body.location 
	self.destination = destination
	self.stepProgress = 0
end

function beast:interpMove()
	--interpolation with Ease Out movement. This moves the location of the creature
	self.body.location = self.stepLocat + ((self.stepProgress^.5) * (self.destination-self.stepLocat))
end

function beast:fireWeapon()  --doesnt actually fire the weapon
	self.ageLastFire = self.age
	Sound:playMad()
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

function beast:drawSprite(sprite, u0, scale)
	local uLocat =  self.stepLocat + ((u0^.5) * (self.destination-self.stepLocat))
	local xOff = sprite:getWidth()/2
	local yOff = sprite:getHeight()/2 + 17 
	local wtf = 90
	if (scale == 1) then wtf = 1 end
	love.graphics.draw(sprite, uLocat.x, uLocat.y - yOff, wtf,1,scale, scale)
end

function beast:drawSide()
	love.graphics.setColor(255,255,255,255)
	local u0 = self.stepProgress + .05
	local u1 = self.stepProgress
	local u2 = self.stepProgress - .05
	local u3 = self.stepProgress - .1

	if(u0 > 1) then u0 = 1 end
	if(u2 < 0) then u2 = 0 end
	if(u3 < 0) then u3 = 0 end


	local scale = -1
	if(self.stepLocat.x > self.destination.x) then  scale = 1 end


	self:drawSprite(leftSprite[5], u0, scale)
	
	love.graphics.setColor(self.body.rgba)
	self:drawSprite(leftSprite[4], u3, scale)
	self:drawSprite(leftSprite[3], u2, scale)
	self:drawSprite(leftSprite[2], u1, scale)
	self:drawSprite(leftSprite[1], u0, scale)

	love.graphics.setColor(255,255,255,255)
	self:drawSprite(leftSprite[6], u1, scale)
	self:drawSprite(leftSprite[7], u0, scale)

end

function beast:draw()
	if(consts.DEBUG) then
		self.body:draw()
	end

	self:drawSide()
end

return beast








