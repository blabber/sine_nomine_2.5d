local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.position = require "sn.position"
sn.tile = require "sn.tile"

local M = { }

local Player = sn.entities.entity.new {
	lastPosition = nil,
	isVisible = true,
	isBlocking = true,
	collisionPriority = 10
}

function M.new(x, y)
	local t = sn.tile.new(
		sn.position.new(x, y),
		'@')
	t:setColor(1, 1, 0)

	return Player:new { tile = t }
end

function Player:handleCollision(entity)
	if entity.isBlocking and
		self.tile.position == entity.tile.position then

		self.tile.position = self.lastPosition
	end
end

function Player:moveTo(x, y)
	self.lastPosition = self.tile.position
	self.tile.position = sn.position.new(x, y)
end

return M
