local M = { }

local Entity = {
	tile = nil,

	collisionPriority = 0,

	isVisible = false,
	isOpaque = false,
	isBlocking = false,
	isKnown = false
}

function M.new(data)
	return Entity:new(data)
end

function Entity:new(data)
	data = data or { }

	self.__index = self
	setmetatable(data, self)

	return data
end

function Entity:draw(heightLevel, vanishingPoint)
	local c = {
		self.tile.color[1],
		self.tile.color[2],
		self.tile.color[3]
	}

	local l = self.tile.heightLevels
	if self.isVisible then
		self.isKnown = true
	else
		c = { 1, 1, 1 }
		l = 0
	end

	if self.isKnown and heightLevel <= l then
		self.tile:draw(heightLevel, vanishingPoint, c)
	end
end

function Entity:checkCollision(entity)
	if self == entity then
		return
	end

	if self.tile.position == entity.tile.position then
		if self.collisionPriority >= entity.collisionPriority then
			self:handleCollision(entity)
			entity:handleCollision(self)
		else
			entity:handleCollision(self)
			self:handleCollision(entity)
		end

		return true
	end

	return false
end

function Entity:handleCollision(entity)
end

function Entity:act(player, findPathFunc)
end

return M
