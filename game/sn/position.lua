local M = {}

local Position = { }

function M.new(x, y, screenFactorX, screenFactorY)
	local p = {
		x = x or 0,
		y = y or 0,
		screenFactorX = screenFactorX or 1,
		screenFactorY = screenFactorY or 1
	}
	Position.__index = Position
	setmetatable(p, Position)

	return p
end

function Position:getScreenX()
	return self.x * self.screenFactorX
end

function Position:getScreenY()
	return self.y * self.screenFactorY
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
	return M.new(self.x, self.y, self.screenFactorX, self.screenFactorY)
end

return M
