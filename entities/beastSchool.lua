--[[ list operations on a school/herd/whatever of beasts 
]]

local Beast = require "entities.beast"
local Class = require "hump.class"
local consts = require "consts"

local beastSchool = Class( --  constructor
		function(self)
			self.school = {}
		end
)

function beastSchool:checkBoundary(beast) --keeps a beast inside game bounds
	local loc = beast:gLocation()
	if(loc.x < 0) then
		beast:sLocation(Vector(consts.SCREEN.x, loc.y))
	elseif(loc.x > consts.SCREEN.x) then
		beast:sLocation(Vector(0, loc.y))	
	end

	loc = beast:gLocation()
	if(loc.y < 0) then
		beast:sLocation(Vector(loc.x, consts.SCREEN.y))
	elseif(loc.y > consts.SCREEN.y) then
		beast:sLocation(Vector(loc.x,0))
	end

	--did i really want to do that? I forget if lua is pass by reference or value TODO
end

function beastSchool:initGenerationZero(numPopulation, numCarrying)
	local color = {0, 200, 0, 255}
	local all1 = true
	local all2 = true
	local i =1 

	for i = 1, numPopulation do
		if(i > numPopulation - numCarrying) then
			all2 = false
		end
		table.insert(self.school, Beast(
				Vector(math.random()*consts.SCREEN.x, math.random()*consts.SCREEN.y),
				color,
				all1, all2
		))
		color[1] = color[2]
		color[2] = color[3]
		if (math.random() > .5) then 
			color[3] = 0
		else
			color[3] = 200
		end
		--TODO preditable color exploit fix here. Do colors better
	end
end

function beastSchool:update(dt)
	--update all beasts in list
	local i =1 
	for i = 1, #self.school do
		self.school[i]:update(dt)  --update
		--check for collisions and boundary exits
		self:checkBoundary(self.school[i])
	end
end



function beastSchool:draw()
	local i =1 
	for i = 1, #self.school do
		self.school[i]:draw()
	end
end



return beastSchool  --aaaaaaaaugh
