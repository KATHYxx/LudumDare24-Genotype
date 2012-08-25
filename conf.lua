local consts = require "consts"

function love.conf(t)
	t.title = consts.TITLE
	t.author = consts.AUTHOR

	t.screen.width = consts.SCREEN.x
	t.screen.height = consts.SCREEN.y
end

