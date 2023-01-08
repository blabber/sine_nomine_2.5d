local M = { }

local Player = { }

function M.new (c)
	local p = { } 
	p.position = c
	p.target = c:clone()

	Player.__index = Player
	setmetatable(p, Player)

	return p
end

function Player:keypressed (key)
	if key == nil or self:isMoving() then
		return
	end

	local t = self.target:clone()

	if key == "up" then
		self.target:setY(self.position:getY() - 1)
	elseif key =="down" then
		self.target:setY(self.position:getY() + 1)
	elseif key =="left" then
		self.target:setX(self.position:getX() - 1)
	elseif key =="right" then
		self.target:setX(self.position:getX() + 1)
	end

	local lg = level[self.target:getY()][self.target:getX()]
	if lg == '#' then
		self.target = t
	end
end

function Player:isMoving()
	return (self.target:getScreenX() ~= self.position:getScreenX()) or
	       (self.target:getScreenY() ~= self.position:getScreenY())
end

function Player:update(dt)
	if not self:isMoving() then
		return
	end

	local s = 100

	if self.position:getScreenX() < self.target:getScreenX() then
		self.position:setScreenX(math.min(self.position:getScreenX() + s * dt,
		                                  self.target:getScreenX()))
	elseif self.position:getScreenX() > self.target:getScreenX() then
		self.position:setScreenX(math.max(self.position:getScreenX() - s * dt,
		                                  self.target:getScreenX()))
	elseif self.position:getScreenY() < self.target:getScreenY() then
		self.position:setScreenY(math.min(self.position:getScreenY() + s * dt,
		                                  self.target:getScreenY()))
	elseif self.position:getScreenY() > self.target:getScreenY() then
		self.position:setScreenY(math.max(self.position:getScreenY() - s * dt,
		                                  self.target:getScreenY()))
	end
end

function Player:draw ()
	love.graphics.setColor(0.5, 0.5, 0)
	love.graphics.print(
		'@',
		self.position:getScreenX(),
		self.position:getScreenY())
end

return M
