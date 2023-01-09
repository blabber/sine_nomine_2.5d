local M = { }

local Tile = { }

function M.new (p, g, h)
	local t = { position = p, glyph = g, height = h }

	Tile.__index = Tile
	setmetatable(t, Tile)

	return t
end

function Tile:draw (l, vp)
	if self.position:getX() == vp:getX() and
	   self.position:getY() == vp:getY() then
		return
	end

	if l > self.height then
		return
	end

	local a = self.position:angle(vp)
	local d = self.position:distance(vp)

	local dx = -(math.cos(a) * (d / 25))
	local dy = -(math.sin(a) * (d / 25))

	local c = 1 - (5-l) * (1 / (5 * 1.25))

	love.graphics.setColor(c, c, c)
	love.graphics.print(
		self.glyph,
		self.position:getScreenX() + l * dx,
		self.position:getScreenY() + l * dy)
end

return M
