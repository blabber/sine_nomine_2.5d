local M = {}

local P = { }
setmetatable(P, { __mode = 'k' })

local Coordinate = { }

function M.new (x, y, xf, yf)
	local c = { }

	Coordinate.__index = Coordinate
	setmetatable(c, Coordinate)

	P[c] = {
		x = x or 0,
		y = y or 0,
		xf = xf or 1,
		yf = yf or 1
	}

	return c
end

function Coordinate:setX (x)
	P[self].x = x
end

function Coordinate:setY (y)
	P[self].y = y
end

function Coordinate:getX ()
	return P[self].x
end

function Coordinate:getY ()
	return P[self].y
end

function Coordinate:getScreenX ()
	return P[self].x * P[self].xf
end

function Coordinate:getScreenY ()
	return P[self].y * P[self].yf
end

function Coordinate:angle (c)
	return math.atan2(
			c:getScreenY() - self:getScreenY(),
			c:getScreenX() - self:getScreenX())
end

function Coordinate:distance (c)
	local dh = c:getScreenX() - self:getScreenX()
	local dv = c:getScreenY() - self:getScreenY()

	return math.sqrt((dh ^2) + (dv ^2))
end

function Coordinate:clone ()
	return M.new(P[self].x, P[self].y, P[self].xf, P[self].yf)
end

return M
