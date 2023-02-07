local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.position = require "sn.position"
sn.tile = require "sn.tile"
sn.constants = require "sn.constants"

local M = { }

local Door = sn.entities.entity.new {
	isOpaque = true,
	isBlocking = true
}

function M.new(x, y)
	local t = sn.tile.new(
		sn.position.new(x, y),
		'+',
		sn.constants.MAXHEIGHTLEVELS)
	t:setColor(1, 1, 0)

	return Door:new{
		tile = t
	}
end

function Door:handleCollision(entity)
	if self.isBlocking then
		self.isBlocking = false
		self.isOpaque = false

		self.tile = sn.tile.new(
			self.tile.position,
			'.')
		self.tile:setColor(1, 1, 0)
	end
end

return M
