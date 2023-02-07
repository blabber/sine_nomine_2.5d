local sn = { }
sn.entities = require "sn.entities"
sn.constants = require "sn.constants"

bresenham = require "lib.bresenham"
board = require "lib.board"
pathfinding = require "lib.pathfinding"

local M = { }

local Level = { }

function M.fromString(levelString)
	local m = 0
	for l in levelString:gmatch('([^\n]+)') do
		m = m > #l and m or #l
	end

	local level = {
		dungeon = board.new(m),
		enemies = { },
		player = nil,
		doUpdate = true
	}
	Level.__index = Level
	setmetatable(level, Level)

	local y = 0
	for l in levelString:gmatch('([^\n]+)') do
		y = y + 1
		for x, g in l:gmatch('()(.)') do
			if g == 's' then
				level.player = sn.entities.newPlayer(x, y)
				level.dungeon:set(x, y, sn.entities.newFloor(x, y))
			elseif g == 'o' then
				level.enemies[#level.enemies+1] = sn.entities.newEnemy(x, y)
				level.dungeon:set(x, y, sn.entities.newFloor(x, y))
			elseif g == '.' then
				level.dungeon:set(x, y, sn.entities.newFloor(x, y))
			elseif g == '#' then
				level.dungeon:set(x, y, sn.entities.newWall(x, y))
			elseif g == '+' then
				level.dungeon:set(x, y, sn.entities.newDoor(x, y))
			end
		end
	end

	return level
end

function Level:findPath(startPosition, endPosition, ignoreEnemies)
	return pathfinding.find(
		startPosition.x,
		startPosition.y,
		endPosition.x,
		endPosition.y,
		function (x, y)
			if x == endPosition.x and y == endPosition.y then
				return true
			end

			if self.dungeon:get(x, y).isBlocking then
				return false
			end

			if not ignoreEnemies then
				for _, e in pairs(self.enemies) do
					if e.isBlocking and
						e.tile.position.x == x and
						e.tile.position.y == y then

						return false
					end
				end
			end

			return true
		end)
end

function Level:calculateFieldOfView()
	local pp = self.player.tile.position

	local function checkVisibility(entity)
		local ep = entity.tile.position

		if pp:distance(ep) >= sn.constants.VISIBILITYRANGE then
			return false
		end

		local l = bresenham.line( pp.x, pp.y, ep.x, ep.y)
		if #l <= 2 then
			return true
		end

		for i = 2, #l-1 do
			local x = l[i][1]
			local y = l[i][2]

			if not self.dungeon:get(x, y) or
				self.dungeon:get(x, y).isOpaque then

				return false
			end
		end

		return true
	end

	for e in self.dungeon:iterate() do
		e.isVisible = checkVisibility(e)
	end

	for _, e in pairs(self.enemies) do
		e.isVisible = checkVisibility(e)
	end
end

function Level:update(dt)
	if not self.doUpdate then
		return
	end
	self.doUpdate = false

	for _, e in pairs(self.enemies) do
		e:act(
			self.player,
			function (player)
				local p = self:findPath(e.tile.position, player.tile.position)
				if p then
					return p
				end

				return self:findPath(e.tile.position, player.tile.position, true)
			end)
	end

	for e in self.dungeon:iterate() do
		self.player:checkCollision(e)
	end

	repeat
		local collisionDetected = false

		for _, e in pairs(self.enemies) do
			collisionDetected = self.player:checkCollision(e) or collisionDetected

			for _, oe in pairs(self.enemies) do
				collisionDetected = e:checkCollision(oe) or collisionDetected
			end
		end

		for _, e in pairs(self.enemies) do
			collisionDetected = self.player:checkCollision(e) or collisionDetected

			for _, oe in pairs(self.enemies) do
				collisionDetected = e:checkCollision(oe) or collisionDetected
			end
		end
	until not collisionDetected

	self:calculateFieldOfView()
end

function Level:keypressed(key)
	local p = self.player.tile.position

	if key == "up" then
		self.player:moveTo(p.x, p.y - 1)
	elseif key =="down" then
		self.player:moveTo(p.x, p.y + 1)
	elseif key =="left" then
		self.player:moveTo(p.x - 1, p.y)
	elseif key =="right" then
		self.player:moveTo(p.x + 1, p.y)
	end

	self.doUpdate = true
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
		for e in self.dungeon:iterate() do
			e:draw(l, cp)
		end

		for _, e in pairs(self.enemies) do
			e:draw(l, cp)
		end
	end

	self.player:draw(0, self.player.tile.position)
end

return M
