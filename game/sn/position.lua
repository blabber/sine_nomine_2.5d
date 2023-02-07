local M = {}

local Position = { }

function M.new(x, y)
	local p = {
		x = x or 0,
		y = y or 0
	}
	Position.__index = Position
	setmetatable(p, Position)

	return p
end

function Position:__eq(otherPosition)
	return
		self.x == otherPosition.x and
		self.y == otherPosition.y
end

function Position:getScreenX()
	return self.x * love.graphics.getFont():getWidth('#')
end

function Position:getScreenY()
	return self.y * love.graphics.getFont():getHeight()
end

function Position:screenAngle(otherPosition)
	return math.atan2(
		otherPosition:getScreenY() - self:getScreenY(),
		otherPosition:getScreenX() - self:getScreenX())
end

function Position:screenDistance(otherPosition)
	local dh = otherPosition:getScreenX() - self:getScreenX()
	local dv = otherPosition:getScreenY() - self:getScreenY()

	return math.sqrt((dh ^2) + (dv ^2))
end

function Position:distance(otherPosition)
	local dh = otherPosition.x - self.x
	local dv = otherPosition.y - self.y

	return math.sqrt((dh ^2) + (dv ^2))
end

function Position:newOffsetPosition(offsetX, offsetY)
	local p = self:clone()

	p.x = p.x + offsetX
	p.y = p.y + offsetY

	return p
end

function Position:clone()
	return M.new(self.x, self.y)
end

return M
