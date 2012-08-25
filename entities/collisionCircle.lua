
local Class = require "hump.class"

local collisionCircle = Class(  --constructor
	function(self, radius, location, rgba)
		self.radius = radius
		self.location = location
		self.rgba = rgba  --color of the circle when drawn
	end
)

function collisionCircle:draw()
	local r,g,b,a = love.graphics.getColor() -- keeps current color to restore 
	love.graphics.setColor(self.rgba[1], self.rgba[2], self.rgba[3], self.rgba[4])	-- color of the circle
	love.graphics.circle("fill", self.location.x, self.location.y, self.radius)
	love.graphics.setColor(r,g,b,a) --restore color
end

function collisionCircle:test(otherCircle) --collision test (test if circles overlap)
	local dist = math.sqrt( (self.location.x-otherCircle.location.x)^2 + 
				(self.location.y-otherCircle.location.y)^2  )	
	return dist < (self.radius + otherCircle.radius)
end

return collisionCircle
