local M = { }

local Player = { }
Player.__index = Player

function M.new(tile)
	local p = {
		tile = tile,
		target = tile.position:clone()
	}
	setmetatable(p, Player)

	return p
end

function Player:isMoving()
	return 
		(self.target:getScreenX() ~= self.tile.position:getScreenX()) or
		(self.target:getScreenY() ~= self.tile.position:getScreenY())
end

function Player:update(deltaTime)
	if not self:isMoving() then
		return
	end

	local delta = 100 * deltaTime

	local position = self.tile.position
	if position:getScreenX() < self.target:getScreenX() then
		position:setScreenX(
			math.min(
				position:getScreenX() + delta,
				self.target:getScreenX()))
	elseif position:getScreenX() > self.target:getScreenX() then
		position:setScreenX(
			math.max(
				position:getScreenX() - delta,
				self.target:getScreenX()))
	elseif position:getScreenY() < self.target:getScreenY() then
		position:setScreenY(
			math.min(
				position:getScreenY() + delta,
				self.target:getScreenY()))
	elseif position:getScreenY() > self.target:getScreenY() then
		position:setScreenY(
				math.max(
					position:getScreenY() - delta,
					self.target:getScreenY()))
	end
end

function Player:draw(heightLevel, vanishingPoint)
	self.tile:draw(heightLevel, vanishingPoint)
end

return M
