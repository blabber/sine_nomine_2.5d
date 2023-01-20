local sn = { }
sn.coordinate = require "sn.coordinate"
sn.global = require "sn.global"
sn.player = require "sn.player"
sn.tile = require "sn.tile"

local M = { }

local function createTile(coordinate, glyph, font)
	local h = 1
	if glyph == '#' then
		h = sn.global.MAXHEIGHTLEVELS
	elseif glyph == 'O' then
		h = 3 <= sn.global.MAXHEIGHTLEVELS
			and 3
			or sn.global.MAXHEIGHTLEVELS
	end

	if glyph == ' ' then
		glyph = '#'
	end

	t = sn.tile.new(coordinate, glyph, font, h)
	
	if t.glyph ~= '#' and t.glyph ~= '.' then
		t:setColor(1, 0, 0)
	end

	return t
end

local private = { }
setmetatable(private, { __mode = 'k' })

local Level = { }
Level.__index = Level

function M.fromString(font, levelString)
	local newLevel = { }
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

			local c = sn.coordinate.new(x, y, w, h)

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

	local t = player.target:clone()

	if key == "up" then
		player.target:setY(player.tile.position:getY() - 1)
	elseif key =="down" then
		player.target:setY(player.tile.position:getY() + 1)
	elseif key =="left" then
		player.target:setX(player.tile.position:getX() - 1)
	elseif key =="right" then
		player.target:setX(player.tile.position:getX() + 1)
	end

	local tiles = private[self].tiles
	local g = tiles[player.target:getY()][player.target:getX()].glyph
	if g == '#' then
		player.target = t
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
				t:draw(l, player.tile.position)
			end
		end
	end

	player:draw(0, player.tile.position)
end

return M
