local Vector = require "hump.vector"

local consts = {} --silly global constants
--game
consts.AUTHOR = "Katherine Blizard"
consts.TITLE = "The Omnicide Genotype"
consts.SCREEN = Vector(1024, 768)
consts.DEBUG = false
consts.STARTING_BEASTS = 3        --number of beasts in a new game, level 1
consts.STARTING_CARRIERS = 1      --number of omnicide carriers in a new game, level 1

--beasts
consts.COLRADIUS = 25 -- collision circle radius 
consts.DIST_RANGE = 450 -- how near a beast looks to move
consts.SPEED = 1.5     --about how many seconds it takes to complete a movement                --turned out to be a global rather than a const >_>
consts.COOLOFF = 10   --cooloff length (in seconds) between actions taken
consts.WEAPON_COOL = 3   --cooloff time for weapon firing (for beasts)
consts.PRE_AGE = -10      --starting "cooldown" at birth
consts.RAGE_AGE = 5      --age (seconds) at which to go omnicidal
consts.LONELY_AGE = 20
consts.BEAST_HEALTH = 10 

--death waves
consts.DEATH_RADIUS = 20        -- starting collision radius of the attack
consts.DEATH_MAX_RADIUS = 200   -- ending radius of attack
consts.EYE_RADIUS = 15          -- starting eye of the attack radius (safety)
consts.EYE_MAX_RADIUS = 150      -- ending eye of the attack radius (safety)
consts.DEATH_COLOR = {55, 0, 150, 75}
consts.EYE_COLOR = {40, 20, 100, 40}
consts.WAVE_FADE = 1            --seconds in time that the attack wave lasts 

--sounds
consts.HAPPY_VOL = .7
consts.SAD_VOL = .9
consts.MAD_VOL = .9
consts.LOVE_VOL = .9
consts.SHOOT_VOL = .9
consts.HIT_VOL = 1 
consts.HISS_VOL = .9 
consts.TICK_VOL =  1.5
consts.CONFIRM_VOL = 1
consts.WIN_VOL = 1 

return consts --allows this to be loaded as a module
