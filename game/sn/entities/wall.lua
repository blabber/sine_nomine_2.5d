local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.constants = require "sn.constants"
sn.position = require "sn.position"
sn.tile = require "sn.tile"

local M = { }

local Wall = sn.entities.entity.new {
	isOpaque = true,
	isBlocking = true
}

function M.new(x, y)
	local t = sn.tile.new(
		sn.position.new(x, y),
		'#',
		sn.constants.MAXHEIGHTLEVELS)
	t:setColor(1, 1, 0)

	return Wall:new{
		tile = t
	}
end

return M
