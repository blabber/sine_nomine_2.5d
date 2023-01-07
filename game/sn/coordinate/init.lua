local M = {}

local Coordinate = { }

function M.new (x, y)
	local c = {
		x = x or 0,
		y = y or 0
	}

	Coordinate.__index = Coordinate
	setmetatable(c, Coordinate)

	return c
end

function Coordinate:new (x, y)
	local c = {
		x = x or 0,
		y = y or 0
	}

	self.__index = self
	setmetatable(c, self)

	return c
end

function Coordinate:angle (c)
	return math.atan2(c.y - self.y, c.x - self.x)
end

function Coordinate:distance (c)
	local dh = c.x - self.x
	local dv = c.y - self.y

	return math.sqrt((dh ^2) + (dv ^2))
end

function Coordinate:clone ()
	return Coordinate:new(self.x, self.y)
end

return M
