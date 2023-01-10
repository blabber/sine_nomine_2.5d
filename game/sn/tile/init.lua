local M = { }

local Tile = { }
Tile.__index = Tile

function M.new(position, glyph, font, heightLevels)
	local t = {
		position = position,
		glyph = glyph,
		font = font,
		heightLevels = heightLevels,
		color = { 1, 1, 1 }
	}
	setmetatable(t, Tile)

	return t
end

function Tile:draw(heightLevel, vanishingPoint)
	if heightLevel >= self.heightLevels then
		return
	end

	love.graphics.setFont(self.font)

	if heightLevel == 0 then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle(
			"fill",
			self.position:getScreenX(),
			self.position:getScreenY(),
			self.font:getWidth(self.glyph),
			self.font:getHeight())
	end

	local a = self.position:angle(vanishingPoint)
	local d = self.position:distance(vanishingPoint)

	local dx = -(math.cos(a) * (d / 25)) * heightLevel
	local dy = -(math.sin(a) * (d / 25)) * heightLevel

	local c = { }
	for _, v in ipairs(self.color) do
		c[#c+1] = v - (5 - heightLevel) * (1 / (5 * 1.5))
	end

	love.graphics.setColor(c[1], c[2], c[3])
	love.graphics.print(
		self.glyph,
		self.position:getScreenX() + dx,
		self.position:getScreenY() + dy)
end

function Tile:setColor(r, g, b)
	self.color = { r, g, b }
end

return M
