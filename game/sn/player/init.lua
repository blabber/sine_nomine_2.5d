local M = { }

local Player = { }
Player.__index = Player

function M.new(c)
	local p = {
		position = c,
		target = c:clone()
	}
	setmetatable(p, Player)

	return p
end

function Player:isMoving()
	return 
		(self.target:getScreenX() ~= self.position:getScreenX()) or
		(self.target:getScreenY() ~= self.position:getScreenY())
end

function Player:update(deltaTime)
	if not self:isMoving() then
		return
	end

	local delta = 100 * deltaTime

	if self.position:getScreenX() < self.target:getScreenX() then
		self.position:setScreenX(
			math.min(
				self.position:getScreenX() + delta,
				self.target:getScreenX()))
	elseif self.position:getScreenX() > self.target:getScreenX() then
		self.position:setScreenX(
			math.max(
				self.position:getScreenX() - delta,
				self.target:getScreenX()))
	elseif self.position:getScreenY() < self.target:getScreenY() then
		self.position:setScreenY(
			math.min(
				self.position:getScreenY() + delta,
				self.target:getScreenY()))
	elseif self.position:getScreenY() > self.target:getScreenY() then
		self.position:setScreenY(
				math.max(
					self.position:getScreenY() - delta,
					self.target:getScreenY()))
	end
end

function Player:draw()
	love.graphics.setColor(0.5, 0.5, 0)
	love.graphics.print(
		'@',
		self.position:getScreenX(),
		self.position:getScreenY())
end

return M
