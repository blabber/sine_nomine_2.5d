local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.constants = require "sn.constants"
sn.position = require "sn.position"
sn.tile = require "sn.tile"

local M = { }

local Enemy = sn.entities.entity.new {
	lastPosition = nil,
	isBlocking = true,
	collisionPriority = 20,
	active = false
}

function M.new(x, y)
	local t = sn.tile.new(
		sn.position.new(x, y),
		'o',
		math.floor(sn.constants.MAXHEIGHTLEVELS / 2))
	t:setColor(1, 0, 0)

	return Enemy:new{
		tile = t
	}
end

function Enemy:act(player, findPathFunc)
	self.lastPosition = self.tile.position

	if self.isVisible then
		self.active = true
	end

	if not self.active then
		return
	end

	local p = findPathFunc(player)
	if not p or #p <= 2 then
		return
	end

	self.tile.position = sn.position.new(p[2][1], p[2][2])
end

function Enemy:handleCollision(entity)
	if entity.isBlocking and
		entity.tile.position == self.tile.position then

		self.tile.position = self.lastPosition
	end
end

function Enemy:draw(heightLevel, vanishingPoint)
	self.isKnown = self.isVisible

	getmetatable(Enemy).draw(self, heightLevel, vanishingPoint)
end

return M
