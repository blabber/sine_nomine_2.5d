local M = {}

local private = { }
setmetatable(private, { __mode = 'k' })

local Position = { }

function M.new(x, y, screenFactorX, screenFactorY)
	local p = { }
	Position.__index = Position
	setmetatable(p, Position)

	private[p] = {
		x = x or 0,
		y = y or 0,
		screenFactorX = screenFactorX or 1,
		screenFactorY = screenFactorY or 1
	}

	return p
end

function Position:setX(x)
	private[self].x = x
end

function Position:setY(y)
	private[self].y = y
end

function Position:getX()
	return private[self].x
end

function Position:getY()
	return private[self].y
end

function Position:getScreenX()
	return private[self].x * private[self].screenFactorX
end

function Position:getScreenY()
	return private[self].y * private[self].screenFactorY
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
	local dh = otherCoordinate:getX() - self:getX()
	local dv = otherCoordinate:getY() - self:getY()

	return math.sqrt((dh ^2) + (dv ^2))
end

function Position:newOffsetPosition(offsetX, offsetY)
	local p = self:clone()

	p:setX(p:getX() + offsetX)
	p:setY(p:getY() + offsetY)

	return p
end

function Position:clone()
	local p = private[self]

	return M.new(p.x, p.y, p.screenFactorX, p.screenFactorY)
end

return M
