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
		self.position.y = self.position.y - tileDimension.y
	elseif key =="down" then
		self.position.y = self.position.y + tileDimension.y
	elseif key =="left" then
		self.position.x = self.position.x - tileDimension.x
	elseif key =="right" then
		self.position.x = self.position.x + tileDimension.x
	end

	local lx = (self.position.x) / tileDimension.x
	local ly = (self.position.y) / tileDimension.y
	local lg = level[ly][lx]
	if lg == '#' then
		self.position = t
	end
end

function Player:draw ()
	love.graphics.setColor(0.5, 0.5, 0)
	love.graphics.print(
		'@',
		self.position.x,
		self.position.y)
end

return M
