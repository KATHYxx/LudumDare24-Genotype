--[[ 
	Crosshair that represents the player's aim
]]

local Class = require "hump.class"
local CollisionCircle = require "entities.collisionCircle"
local Beast = require "entities.beast"
local consts = require "consts"

local sprite = love.graphics.newImage("assets/cross3.png")

local crosshair = Class (
			function(self)
				self.body = CollisionCircle(consts.COLRADIUS, Vector(consts.SCREEN.x/2, consts.SCREEN.y/2), {255,255,255,100})
			end
)

function crosshair:testBeast(oBeast)
	return self.body:test(oBeast.body)
end

function crosshair:update(dt)
	self.body.location = Vector(love.mouse.getX(), love.mouse.getY())
end

function crosshair:fire()
	Sound:playShoot()
end

function crosshair:draw()
	if(consts.DEBUG) then
		self.body:draw()
	end

	local xOff = sprite:getWidth()/2	
	local yOff = sprite:getHeight()/2	
	love.graphics.draw(sprite, self.body.location.x - xOff, self.body.location.y - yOff )
end

return crosshair
