local M = { }

local Entity = {
	tile = nil,

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
		c = { 1, 1, 0 }
		self.isKnown = true
	else
		l = 0
	end

	if self.isKnown and heightLevel <= l then
		self.tile:draw(heightLevel, vanishingPoint, c)
	end
end

function Entity:handleCollision(entity)
end

return M
