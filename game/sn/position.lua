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

function Position:getScreenX()
	return self.x * love.graphics.getFont():getWidth('#')
end

function Position:getScreenY()
	return self.y * love.graphics.getFont():getHeight()
end

function Position:screenAngle(otherCoordinate)
	return math.atan2(
		otherCoordinate:getScreenY() - self:getScreenY(),
		otherCoordinate:getScreenX() - self:getScreenX())
end

function Position:screenDistance(otherCoordinate)
	local dh = otherCoordinate:getScreenX() - self:getScreenX()
	local dv = otherCoordinate:getScreenY() - self:getScreenY()

	return math.sqrt((dh ^2) + (dv ^2))
end

function Position:distance(otherCoordinate)
	local dh = otherCoordinate.x - self.x
	local dv = otherCoordinate.y - self.y

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
