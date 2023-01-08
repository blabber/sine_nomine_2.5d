local M = { }

local Player = { }

function M.new (c)
	local p = { } 
	p.position = c

	Player.__index = Player
	setmetatable(p, Player)

	return p
end

function Player:keypressed (key)
	local t = self.position:clone()

	if key == "up" then
		self.position:setY(self.position:getY() - 1)
	elseif key =="down" then
		self.position:setY(self.position:getY() + 1)
	elseif key =="left" then
		self.position:setX(self.position:getX() - 1)
	elseif key =="right" then
		self.position:setX(self.position:getX() + 1)
	end

	local lg = level[self.position:getY()][self.position:getX()]
	if lg == '#' then
		self.position = t
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
