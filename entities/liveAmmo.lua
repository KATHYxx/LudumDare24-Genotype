--[[
	Maintains the list of deathWaves currently on the screen. Removing those that are expired
]]

local Class = require "hump.class"
local DeathWave = require "entities.deathWave"
local consts = require "consts"

local liveAmmo = Class( --constructor
			function(self)
				self.ammo = {}
			end
)

function liveAmmo:reset()
	self.ammo = {}
end

function liveAmmo:addWave(location)
	if(not(location.x == -1 and location.y == -1)) then
		table.insert(self.ammo, DeathWave(location))
	end
end

function liveAmmo:update(dt)
	local deletedIndex = -1
	for i=1, #self.ammo do
		if(self.ammo[i]:update(dt)) then
			deletedIndex = i
		end
	end

	if(deletedIndex > 0) then
		table.remove(self.ammo, deletedIndex)
	end
end

function liveAmmo:draw()
	for i=1, #self.ammo do
		self.ammo[i]:draw()
	end
end

return liveAmmo
