--[[ list operations on a school/herd/whatever of beasts 
]]

local Beast = require "entities.beast"
local Class = require "hump.class"
local consts = require "consts"

local startingColors = { {255,0,0,255} , {0,255,0,255} , {0,0,255,255} ,
			 {255,255,0,255} , {255, 0, 255,255} , {255,255,255,255} , {0,255,255,255} }
			 



local beastSchool = Class( --  constructor
		function(self)
			self.school = {}
			self.newAttack = Vector(-1,-1) --attacks with negatives are not new attacks
		end
)

function beastSchool:gNewAttack()
	return Vector(self.newAttack.x, self.newAttack.y)
end

function beastSchool:reset()
	self.school = {}
	self.newAttack = Vector(-1,-1)
end

function beastSchool:remove(index)
	table.remove(self.school, index)
end

function beastSchool:checkBoundary(beast) --keeps a beast inside game bounds
	local loc = beast:gLocation()
	local dest = Vector(1,1) 	
	
	--prevents game from getting too stale. causes a chase to happen
	if(beast:horny() and beast.stepProgress >= .96) then
		target = math.random(#self.school) 
		dest = self.school[target]:gLocation()
		beast:setDestination(dest)
	end
	
	dest = Vector(consts.SCREEN.x/2 + (loc.x-consts.SCREEN.x)/4, 
			    consts.SCREEN.y/2 + (loc.y-consts.SCREEN.y)/4)

	--outside of bounds changes
	if(loc.x < 0) then
		beast:setDestination(dest)
	elseif(loc.x > consts.SCREEN.x) then
		beast:setDestination(dest)
	end

	loc = beast:gLocation()
	if(loc.y < 0) then
		beast:setDestination(dest)
	elseif(loc.y > consts.SCREEN.y) then
		beast:setDestination(dest)
	end
end

function beastSchool:mack(p1, p2)  --two parents with index p1 and p2 make babby
	table.insert(self.school, Beast(
					Vector(
						(self.school[p1]:gLocation().x+self.school[p2]:gLocation().x)/2, 
						(self.school[p1]:gLocation().y+self.school[p2]:gLocation().y)/2),
					{(self.school[p1]:gRed()+self.school[p2]:gRed())/2, (self.school[p1]:gGreen()+self.school[p2]:gGreen())/2,
						(self.school[p1]:gBlue()+self.school[p2]:gBlue())/2, (self.school[p1]:gAlpha()+self.school[p2]:gAlpha())/2},
					self.school[p1]:passGene(),
					self.school[p2]:passGene()
			)
	)

	Sound:playLove() 
end

function beastSchool:mackTest()
	local i = 1
	local j = 1
	for i = 1, #self.school do
		for j = i+1, #self.school do
			if(self.school[i]:ready() and self.school[j]:ready() and 
			   self.school[i]:collisionTest(self.school[j])) then
				self:mack(i, j)
				return
			end
		end
	end
end

-- starting population must not be greater than the number of starting colors available
function beastSchool:initGenerationZero(numPopulation, numCarrying)
	local all1 = true
	local all2 = true
	local i =1 
	local targetIndexes = {}

	for i = 1, numPopulation do  --generate each member of the population
		if(i > numPopulation - numCarrying) then
			all2 = false
		end
		table.insert(self.school, Beast(
				Vector(math.random()*consts.SCREEN.x, math.random()*consts.SCREEN.y),
				startingColors[i],
				all1, all2
		))

	end

	--randomly assign the omnicide genotype to numCarrying amount of beasts
	for i=1, numCarrying do
		table.insert(targetIndexes, math.random(numPopulation))
	end	

	for i=1, numCarrying do
		self.school[targetIndexes[i]]:assignCarrier()
	end

end

function beastSchool:update(dt)
	--update all beasts in list
	self.newAttack = Vector(-1,-1) 
	local i =1 
	for i = 1, #self.school do
		if(self.school[i]:update(dt)) then --update
			self.newAttack = self.school[i]:gLocation()
		end
		--check for boundary exits
		self:checkBoundary(self.school[i])
	end

	if(math.random() < .01) then
		Sound:playHappy()
	end
	
	--collision check
	self:mackTest()
end



function beastSchool:draw()
	local i =1 
	for i = 1, #self.school do
		self.school[i]:draw()
	end
end



return beastSchool  --aaaaaaaaugh
