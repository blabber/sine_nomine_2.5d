local M = { }

local Creature = { }

function M.new(tile)
	local p = { tile = tile }
	Creature.__index = Creature
	setmetatable(p, Creature)

	return p
end

function Creature:draw(heightLevel, vanishingPoint)
	self.tile:draw(heightLevel, vanishingPoint)
end

return M
