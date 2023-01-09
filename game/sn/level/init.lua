local sn = { }
sn.coordinate = require "sn.coordinate"
sn.player = require "sn.player"
sn.tile = require "sn.tile"

local M = { }

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
			local c =
				sn.coordinate.new(#tilesRow+1, #tiles,
					font:getWidth('#'), font:getHeight('#'))

			if g == 's' then
				g = '.'
				private[newLevel].player = sn.player.new(c:clone())
			end

			local h = 1
			if g == '#' then
				h = 5
			end

			if g == ' ' then
				g = '#'
			end

			tilesRow[#tilesRow+1] = sn.tile.new(c:clone(), g, h)
		end
	end

	return newLevel
end

function Level:update(dt)
	private[self].player:update(dt)
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
	local lg = tiles[player.target:getY()][player.target:getX()].glyph
	if lg == '#' then
		player.target = t
	end
end

function Level:draw ()
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
