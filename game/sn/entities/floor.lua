local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.position = require "sn.position"
sn.tile = require "sn.tile"

local M = { }

local Floor = sn.entities.entity.new()

function M.new(x, y)
	return Floor:new{
		tile = sn.tile.new(
			sn.position.new(x, y),
			'.')
	}
end

return M
