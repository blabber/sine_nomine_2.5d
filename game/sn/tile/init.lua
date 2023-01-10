local M = { }

local Tile = { }
Tile.__index = Tile

function M.new(position, glyph, heigtLevels)
	local t = {
		position = position,
		glyph = glyph,
		heightLevels = heigtLevels
	}
	setmetatable(t, Tile)

	return t
end

function Tile:draw(heightLevel, vanishingPoint)
	if self.position:getX() == vanishingPoint:getX() and
	   self.position:getY() == vanishingPoint:getY() then
		return
	end

	if heightLevel >= self.heightLevels then
		return
	end

	local a = self.position:angle(vanishingPoint)
	local d = self.position:distance(vanishingPoint)

	local dx = -(math.cos(a) * (d / 25)) * heightLevel
	local dy = -(math.sin(a) * (d / 25)) * heightLevel

	local c = 1 - (5 - heightLevel) * (1 / (5 * 1.25))

	love.graphics.setColor(c, c, c)
	love.graphics.print(
		self.glyph,
		self.position:getScreenX() + dx,
		self.position:getScreenY() + dy)
end

return M
