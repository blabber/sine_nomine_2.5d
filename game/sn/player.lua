local M = { }

local Player = { }

function M.new(tile)
	local p = { tile = tile }
	Player.__index = Player
	setmetatable(p, Player)

	return p
end

function Player:draw(heightLevel, vanishingPoint)
	self.tile:draw(heightLevel, vanishingPoint)
end

return M
