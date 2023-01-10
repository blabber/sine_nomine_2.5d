local sn = { }
sn.coordinate = require "sn.coordinate"
sn.player = require "sn.player"
sn.tile = require "sn.tile"

local M = { }

local function createTile(coordinate, glyph)
	local h = 1
	if glyph == '#' then
		h = 5
	end

	if glyph == ' ' then
		glyph = '#'
	end

	return sn.tile.new(coordinate, glyph, h)
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
			local h = font:getHeight('#')

			local c = sn.coordinate.new(x, y, w, h)

			if g == 's' then
				g = '.'
				private[newLevel].player = sn.player.new(c:clone())
			end

			tilesRow[#tilesRow+1] = createTile(c:clone(), g)
		end
	end

	return newLevel
end

function Level:update(deltaTime)
	private[self].player:update(deltaTime)
end

function Level:keypressed(key)
	local player = private[self].player

	if player:isMoving() then
		return
	end

	local t = player.target:clone()

	if key == "up" then
		player.target:setY(player.position:getY() - 1)
	elseif key =="down" then
		player.target:setY(player.position:getY() + 1)
	elseif key =="left" then
		player.target:setX(player.position:getX() - 1)
	elseif key =="right" then
		player.target:setX(player.position:getX() + 1)
	end

	local tiles = private[self].tiles
	local g = tiles[player.target:getY()][player.target:getX()].glyph
	if g == '#' then
		player.target = t
	end
end

function Level:draw()
	local player = private[self].player

	love.graphics.translate(
		love.graphics.getWidth() / 2 - player.position:getScreenX(),
		love.graphics.getHeight() / 2 - player.position:getScreenY())

	local tiles = private[self].tiles
	for l = 0, 4 do
		for _, r in pairs(tiles) do
			for _, t in pairs(r) do
				t:draw(l, player.position)
			end
		end
	end

	player:draw()
end

return M
