local sn = { }
sn.position = require "sn.position"
sn.constants = require "sn.constants"
sn.creature = require "sn.creature"
sn.tile = require "sn.tile"

bresenham = require "lib.bresenham"

local M = { }

local function createTile(position, glyph, font)
	local h = 1
	if glyph == '#' then
		h = sn.constants.MAXHEIGHTLEVELS
	end

	t = sn.tile.new(position, glyph, font, h)
	
	if t.glyph ~= '#' and t.glyph ~= '.' then
		t:setColor(1, 0, 0)
	end

	return t
end


local function conditionallyDrawDungeonTile(self, tile, heightLevel)
	local p = self.player.tile.position

	local c = {
		tile.color[1],
		tile.color[2],
		tile.color[3]
	}

	local cl = tile.heightLevels
	if self:checkVisibility(p, tile.position) then
		c = { 1, 1, 0 }
		tile.known = true
	else
		cl = 0
	end

	local vp = p:newOffsetPosition(0.5, 0.5)
	if tile.known and heightLevel <= cl then
		tile:draw(heightLevel, vp, c)
	end
end

local Level = { }

function M.fromString(font, levelString)
	local level = {
		tiles = { },
		font = font,
		player = nil
	}
	Level.__index = Level
	setmetatable(level, Level)

	local y = 0
	for l in levelString:gmatch('([^\n]+)') do
		y = y + 1
		for x, g in l:gmatch('()(.)') do
			local w = font:getWidth('#')
			local h = font:getHeight()

			local c = sn.position.new(x, y, w, h)

			if g == 's' then
				g = '.'

				local pt = createTile(c:clone(), '@', font)

				pt:setColor(1, 1, 0)
				level.player = sn.creature.new(pt)
			end

			if not level.tiles[x] then
				level.tiles[x] = { }
			end

			level.tiles[x][y] = createTile(c:clone(), g, font)
		end
	end

	return level
end

function Level:checkVisibility(position1, position2)
	if position1:distance(position2) >= sn.constants.VISIBILITYRANGE then
		return false
	end

	local l =
		bresenham.line(
			position1.x, position1.y,
			position2.x, position2.y)
	if #l <= 2 then
		return true
	end

	for i = 2, #l-1 do
		local x = l[i][1]
		local y = l[i][2]

		if not self.tiles[x][y] or
			self.tiles[x][y].glyph == '#' then

			return false
		end
	end

	return true
end

function Level:keypressed(key)
	local p = self.player.tile.position
	local t = p:clone()

	if key == "up" then
		p.y = p.y - 1
	elseif key =="down" then
		p.y = p.y + 1
	elseif key =="left" then
		p.x = p.x - 1
	elseif key =="right" then
		p.x = p.x + 1
	end

	local g = self.tiles[p.x][p.y].glyph
	if g == '#' then
		self.player.tile.position = t
	end
end

function Level:movePlayerTowards(x, y)
	local a = math.deg(
		math.atan2(
			y - love.graphics.getHeight() / 2,
			x - love.graphics.getWidth() / 2))

	if a < 0 then
		a = a + 360
	end

	if (a > 45) and (a <= 135) then
		self:keypressed("down")
	elseif (a > 135) and (a <= 225) then
		self:keypressed("left")
	elseif (a > 225) and (a <= 315) then
		self:keypressed("up")
	else
		self:keypressed("right")
	end
end

function Level:draw()
	local cp = self.player.tile.position:newOffsetPosition(0.5, 0.5)

	love.graphics.translate(
		love.graphics.getWidth() / 2 - cp:getScreenX(),
		love.graphics.getHeight() / 2 - cp:getScreenY())

	for l = 0, sn.constants.MAXHEIGHTLEVELS-1 do
		for _, c in pairs(self.tiles) do
			for _, t in pairs(c) do
				conditionallyDrawDungeonTile(self, t, l)
			end
		end
	end

	self.player:draw(0, self.player.tile.position)
end

return M
