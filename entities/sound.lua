--[[
	Sound handler
]]

local Class = require "hump.class"
local consts = require "consts"

local sounds = Class( --constructor
		function(self)
			self.winAge = 0
			self.happy = { 
				love.audio.newSource("sfx/happy_1.wav", "static"),
				love.audio.newSource("sfx/happy_2.wav", "static"),
				love.audio.newSource("sfx/happy_3.wav", "static"),
				love.audio.newSource("sfx/happy_4.wav", "static")
			}
			self.sad = {
				love.audio.newSource("sfx/sad_1.wav", "static"),
				love.audio.newSource("sfx/sad_2.wav", "static"),
				love.audio.newSource("sfx/sad_3.wav", "static"),
				love.audio.newSource("sfx/sad_4.wav", "static")
			}
			self.mad = {
				love.audio.newSource("sfx/mad_1.wav", "static"),
				love.audio.newSource("sfx/mad_2.wav", "static")
			}
			self.love = {
				love.audio.newSource("sfx/love_1.wav", "static"),
				love.audio.newSource("sfx/love_2.wav", "static")
			}

			self.shoot = {
				love.audio.newSource("sfx/preshot.wav", "static")
			}
			self.hit = {
				love.audio.newSource("sfx/shot_1.wav", "static"),
				love.audio.newSource("sfx/shot_2.wav", "static"),
				love.audio.newSource("sfx/shot_3.wav", "static"),
				love.audio.newSource("sfx/shot_4.wav", "static")
			}
			self.tick = {
				love.audio.newSource("sfx/tick.wav", "static")
			}
			self.hiss = {
				love.audio.newSource("sfx/hiss.wav", "static")
			}
			self.win = {
				love.audio.newSource("sfx/win_1.wav", "static"),
				love.audio.newSource("sfx/win_2.wav", "static"),
				love.audio.newSource("sfx/win_3.wav", "static")
			}
			self.confirm = {
				love.audio.newSource("sfx/confirm.wav", "static")
			}
		end
)

function sounds:playRand(list, volume)
	local index = math.random(#list)
	local pitch = 1 - (math.random()*.2)
	list[index]:stop()
	list[index]:setVolume(volume)
	list[index]:setPitch(volume)
	list[index]:setVolume(volume)

	love.audio.play(list[index])
	
end

function sounds:playHappy()
	self:playRand(self.happy, consts.HAPPY_VOL)
end

function sounds:playSad()
	self:playRand(self.sad, consts.SAD_VOL)
end

function sounds:playMad()
	self:playRand(self.mad, consts.MAD_VOL)
end

function sounds:playLove()
	self:playRand(self.love, consts.LOVE_VOL)
end

function sounds:playShoot()
	self:playRand(self.shoot, consts.SHOOT_VOL)
end

function sounds:playHit()
	self:playRand(self.hit, consts.HIT_VOL)
end

function sounds:playTick()
	self:playRand(self.tick, consts.TICK_VOL)
end

function sounds:playHiss()
	self:playRand(self.hiss, consts.HISS_VOL)
end

function sounds:playConfirm()
	self.confirm[1]:stop()

	self.confirm[1]:setVolume(consts.CONFIRM_VOL)
	love.audio.play(self.confirm[1])
end

function sounds:setWin()
	self.winAge = 0
end

function sounds:playWin(index)
	self.win[index]:stop()

	
	self.win[index]:setVolume(consts.WIN_VOL)
	love.audio.play(self.win[index])
end


return sounds








