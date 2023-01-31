local sn = { }
sn.position = require "sn.position"
sn.tile = require "sn.tile"
sn.constants = require "sn.constants"

local M = { }

-- {{{ Entity
local Entity = {
	tile = nil,

	isVisible = false,
	isOpaque = false,
	isBlocking = false,
	isKnown = false
}

function Entity:new(data)
	data = data or { }

	self.__index = self
	setmetatable(data, self)

	return data
end

function Entity:draw(heightLevel, vanishingPoint)
	local c = {
		self.tile.color[1],
		self.tile.color[2],
		self.tile.color[3]
	}

	local l = self.tile.heightLevels
	if self.isVisible then
		c = { 1, 1, 0 }
		self.isKnown = true
	else
		l = 0
	end

	if self.isKnown and heightLevel <= l then
		self.tile:draw(heightLevel, vanishingPoint, c)
	end
end

function Entity:handleCollision(entity)
end

-- }}}

-- {{{ Wall

local Wall = Entity:new()

function M.newWall(x, y)
	return Wall:new{
		tile = sn.tile.new(
			sn.position.new(x, y),
			'#',
			sn.constants.MAXHEIGHTLEVELS),
		isOpaque = true,
		isBlocking = true
	}
end

-- }}}

-- {{{ Floor

local Floor = Entity:new()

function M.newFloor(x, y)
	return Floor:new{
		tile = sn.tile.new(
			sn.position.new(x, y),
			'.')
	}
end

-- }}}

-- {{{ Door

local Door = Entity:new()

function M.newDoor(x, y)
	return Door:new{
		tile = sn.tile.new(
			sn.position.new(x, y),
			'+',
			sn.constants.MAXHEIGHTLEVELS),
		isOpaque = true,
		isBlocking = true
	}
end

function Door:handleCollision(entity)
	if entity.tile.position.x == self.tile.position.x and
		 entity.tile.position.y == self.tile.position.y and
		 self.isBlocking then

		 self.isBlocking = false
		 self.isOpaque = false

		 self.tile = sn.tile.new(
		 	self.tile.position,
			'.')
		
		return true
	end

	return false
end

-- }}}

-- {{{ Player

local Player = Entity:new{
	lastPosition = nil
}

function M.newPlayer(x, y)
	local t = sn.tile.new(
		sn.position.new(x, y),
		'@')
	t:setColor(1, 1, 0)

	return Player:new{
		tile = t,
		isVisible = true
	}
end

function Player:handleCollision(entity)
	if entity:handleCollision(self) then
		self.tile.position = self.lastPosition
		return
	end

	if entity.tile.position.x == self.tile.position.x and
		 entity.tile.position.y == self.tile.position.y and
		 entity.isBlocking then

		 self.tile.position = self.lastPosition
	end

end

function Player:moveTo(x, y)
	self.lastPosition = self.tile.position
	self.tile.position = sn.position.new(x, y)
end

-- }}}

return M
