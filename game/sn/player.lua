local M = { }

local SPEED = 200

local Player = { }

function M.new(tile)
	local p = { tile = tile }
	Player.__index = Player
	setmetatable(p, Player)

	return p
end

function Player:isMoving()
	return
		self.tile.position:getScreenOffsetX() ~= 0 or
		self.tile.position:getScreenOffsetY() ~= 0
end

function Player:update(deltaTime)
	if not self:isMoving() then
		return
	end

	local delta = SPEED * deltaTime

	local position = self.tile.position
	if position:getScreenOffsetX() < 0 then
		position:setScreenOffsetX(
			math.min( 0, position:getScreenOffsetX() + delta))
	elseif position:getScreenOffsetX() > 0 then
		position:setScreenOffsetX(
			math.max( 0, position:getScreenOffsetX() - delta))
	end

	if position:getScreenOffsetY() < 0 then
		position:setScreenOffsetY(
			math.min( 0, position:getScreenOffsetY() + delta))
	elseif position:getScreenOffsetY() > 0 then
		position:setScreenOffsetY(
			math.max( 0, position:getScreenOffsetY() - delta))
	end
end

function Player:draw(heightLevel, vanishingPoint)
	self.tile:draw(heightLevel, vanishingPoint)
end

return M
