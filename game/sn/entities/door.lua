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
	return Door:new{
		tile = sn.tile.new(
			sn.position.new(x, y),
			'+',
			sn.constants.MAXHEIGHTLEVELS)
	}
end

function Door:handleCollision(entity)
	if entity.tile.position.x == self.tile.position.x and
		 entity.tile.position.y == self.tile.position.y and
		 self.isBlocking then

		 self.isBlocking = false
		 self.isOpaque = false

		 self.tile = sn.tile.new(
		 	self.tile.position,
			'.')
		
		return true
	end

	return false
end

return M
