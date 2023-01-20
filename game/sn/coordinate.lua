local M = {}

local private = { }
setmetatable(private, { __mode = 'k' })

local Coordinate = { }
Coordinate.__index = Coordinate

function M.new(x, y, xFactor, yFactor)
	local c = { }
	setmetatable(c, Coordinate)

	private[c] = {
		x = x or 0,
		y = y or 0,
		xFactor = xFactor or 1,
		yFactor = yFactor or 1
	}

	return c
end

function Coordinate:setX(x)
	private[self].x = x
end

function Coordinate:setY(y)
	private[self].y = y
end

function Coordinate:getX()
	return private[self].x
end

function Coordinate:getY()
	return private[self].y
end

function Coordinate:setScreenX(x)
	private[self].x = x / private[self].xFactor
end

function Coordinate:setScreenY(y)
	private[self].y = y / private[self].yFactor
end

function Coordinate:getScreenX()
	return private[self].x * private[self].xFactor
end

function Coordinate:getScreenY()
	return private[self].y * private[self].yFactor
end

function Coordinate:angle(otherCoordinate)
	return math.atan2(
		otherCoordinate:getScreenY() - self:getScreenY(),
		otherCoordinate:getScreenX() - self:getScreenX())
end

function Coordinate:distance(otherCoordinate)
	local dh = otherCoordinate:getScreenX() - self:getScreenX()
	local dv = otherCoordinate:getScreenY() - self:getScreenY()

	return math.sqrt((dh ^2) + (dv ^2))
end

function Coordinate:clone()
	local p = private[self]

	return M.new(p.x, p.y, p.xFactor, p.yFactor)
end

return M
