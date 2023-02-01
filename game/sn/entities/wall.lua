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
	return Wall:new{
		tile = sn.tile.new(
			sn.position.new(x, y),
			'#',
			sn.constants.MAXHEIGHTLEVELS)
	}
end

return M
