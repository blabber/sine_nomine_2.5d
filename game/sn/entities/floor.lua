local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.position = require "sn.position"
sn.tile = require "sn.tile"

local M = { }

local Floor = sn.entities.entity.new()

function M.new(x, y)
	local t = sn.tile.new(
		sn.position.new(x, y),
		'.')
	t:setColor(1, 1, 0)

	return Floor:new{
		tile = t
	}
end

return M
