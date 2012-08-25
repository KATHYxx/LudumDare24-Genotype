local Vector = require "hump.vector"

local consts = {} --silly global constants
--game
consts.AUTHOR = "Katherine Blizard"
consts.TITLE = "The Omnicide Genotype"
consts.SCREEN = Vector(1024, 768)
consts.DEBUG = true

--beasts
consts.COLRADIUS = 25 -- collision circle radius 
consts.DIST_RANGE = 650 -- how near a beast looks to move
consts.COOLOFF = 10   --cooloff length (in seconds) between actions taken
consts.SPEED = 1.5     --about how many seconds it takes to complete a movement

return consts --allows this to be loaded as a module
