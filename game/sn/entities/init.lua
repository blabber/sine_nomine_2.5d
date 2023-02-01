local sn = { }
sn.entities = { }
sn.entities.entity = require "sn.entities.entity"
sn.entities.wall = require "sn.entities.wall"
sn.entities.floor = require "sn.entities.floor"
sn.entities.door = require "sn.entities.door"
sn.entities.player = require "sn.entities.player"

local M = { }

function M.newWall(x, y)
	return sn.entities.wall.new(x, y)
end

function M.newFloor(x, y)
	return sn.entities.floor.new(x, y)
end

function M.newDoor(x, y)
	return sn.entities.door.new(x, y)
end

function M.newPlayer(x, y)
	return sn.entities.player.new(x, y)
end

return M
