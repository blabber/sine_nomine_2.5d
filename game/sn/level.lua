local sn = { }
sn.position = require "sn.position"
sn.global = require "sn.global"
sn.player = require "sn.player"
sn.tile = require "sn.tile"

bresenham = require "bresenham"

local M = { }

local VISIBILITYRANGE = 6.5

local function createTile(position, glyph, font)
	local h = 1
	if glyph == '#' then
		h = sn.global.MAXHEIGHTLEVELS
	elseif glyph == 'O' then
		h = 3 <= sn.global.MAXHEIGHTLEVELS
			and 3
			or sn.global.MAXHEIGHTLEVELS
	end

	t = sn.tile.new(position, glyph, font, h)
	
	if t.glyph ~= '#' and t.glyph ~= '.' then
		t:setColor(1, 0, 0)
	end

	return t
end


local private = { }
setmetatable(private, { __mode = 'k' })

local function conditionallyDrawDungeonTile(self, tile, heightLevel)
	local p = private[self].player.tile.position:clone()

	p:setX(math.floor(p:getX()))
	p:setY(math.floor(p:getY()))

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

	if tile.known and heightLevel <= cl then
		tile:draw(heightLevel, p, c)
	end
end

local Level = { }

function M.fromString(font, levelString)
	local newLevel = { }
	Level.__index = Level
	setmetatable(newLevel, Level)

	local tiles = { }
	private[newLevel] = {
		tiles = tiles,
		font = font
	}

	for l in levelString:gmatch('([^\n]+)') do
		tilesRow = { }
		tiles[#tiles+1] = tilesRow
		for g in l:gmatch('(.)') do
			local x = #tilesRow + 1
			local y = #tiles
			local w = font:getWidth('#')
			local h = font:getHeight()

			local c = sn.position.new(x, y, w, h)

			if g == 's' then
				g = '.'

				local pt = createTile(c:clone(), '@', font)

				pt:setColor(1, 1, 0)
				private[newLevel].player = sn.player.new(pt)
			end

			tilesRow[#tilesRow+1] = createTile(c:clone(), g, font)
		end
	end

	return newLevel
end

function Level:checkVisibility(position1, position2)
	if position1:distance(position2) >= VISIBILITYRANGE then
		return false
	end

	local l =
		bresenham.line(
			position1:getX(), position1:getY(),
			position2:getX(), position2:getY())
	if #l <= 2 then
		return true
	end

	local tiles = private[self].tiles

	for i = 2, #l-1 do
		local x = l[i][1]
		local y = l[i][2]

		if not tiles[y][x] or tiles[y][x].glyph == '#' then
			return false
		end
	end

	return true
end

function Level:update(deltaTime)
	local player = private[self].player

	if player:isMoving() then
		player:update(deltaTime)
		return
	end

	if love.mouse.isDown(1) then
		local x = love.mouse.getX()
		local y = love.mouse.getY()

		self:movePlayerTowards(x, y)
	else
		local t = love.touch.getTouches()
		if t and #t >= 1 then
			local x, y = love.touch.getPosition(t[1])
			self:movePlayerTowards(x, y)
		end
	end
end

function Level:keypressed(key)
	local player = private[self].player

	if player:isMoving() then
		return
	end

	local t = player.tile.position:clone()

	if key == "up" then
		player.tile.position:setY(player.tile.position:getY() - 1)

		player.tile.position:setScreenOffsetX(0)
		player.tile.position:setScreenOffsetY(player.tile:getHeight())
	elseif key =="down" then
		player.tile.position:setY(player.tile.position:getY() + 1)

		player.tile.position:setScreenOffsetX(0)
		player.tile.position:setScreenOffsetY(-player.tile:getHeight())
	elseif key =="left" then
		player.tile.position:setX(player.tile.position:getX() - 1)

		player.tile.position:setScreenOffsetX(player.tile:getWidth())
		player.tile.position:setScreenOffsetY(0)
	elseif key =="right" then
		player.tile.position:setX(player.tile.position:getX() + 1)

		player.tile.position:setScreenOffsetX(-player.tile:getWidth())
		player.tile.position:setScreenOffsetY(0)
	end

	local tiles = private[self].tiles
	local g = tiles[player.tile.position:getY()][player.tile.position:getX()].glyph
	if g == '#' then
		player.tile.position = t
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
	local player = private[self].player

	love.graphics.translate(
		love.graphics.getWidth() / 2 - player.tile.position:getScreenX(),
		love.graphics.getHeight() / 2 - player.tile.position:getScreenY())

	local tiles = private[self].tiles
	for l = 0, sn.global.MAXHEIGHTLEVELS-1 do
		for _, r in pairs(tiles) do
			for _, t in pairs(r) do
				conditionallyDrawDungeonTile(self, t, l)
			end
		end
	end

	player:draw(0, player.tile.position)
end

return M
