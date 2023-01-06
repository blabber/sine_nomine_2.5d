-- Coordinate {{{

Coordinate = { }

function Coordinate:new (x, y)
	local c = {
		x = x or 0,
		y = y or 0
	}

	self.__index = self
	setmetatable(c, self)

	return c
end

function Coordinate:angle (c)
	return math.atan2(c.y - self.y, c.x - self.x)
end

function Coordinate:distance (c)
	local dh = c.x - self.x
	local dv = c.y - self.y

	return math.sqrt((dh ^2) + (dv ^2))
end

function Coordinate:clone ()
	return Coordinate:new(self.x, self.y)
end

--- }}}

-- {{{ Tile

Tile = { }

function Tile:new (p, g, h)
	local t = { position = p, glyph = g, height = h }

	self.__index = self
	setmetatable(t, self)

	return t
end

function Tile:draw (l)
	if self.position.x == player.position.x and
	   self.position.y == player.position.y then
		return
	end

	if l >= self.height then
		return
	end

	local a = self.position:angle(player.position)
	local d = self.position:distance(player.position)

	local dx = -(math.cos(a) * (d / 25))
	local dy = -(math.sin(a) * (d / 25))

	local c = 0;

	c = c + (l+1) * (1 / self.height)
	if l == self.height - 1 then
		c = 1
	end
	love.graphics.setColor(c, c, c)
	love.graphics.print(
		self.glyph,
		self.position.x + l * dx,
		self.position.y + l * dy)
end

-- }}}

-- {{{ Player

Player = { }

function Player:new (c)
	local p = {}
	p.position = c

	self.__index = self
	setmetatable(p, self)

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

-- }}}

function love.load ()
	-- {{{ Level
	level = {
		{ '#', '#', '#', '#', '#', ' ', ' ', '#', '#', '#', '#', '#', ' ', ' ', '#', '#', '#', '#', '#' },
		{ '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#' },
		{ '#', '.', 's', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#' },
		{ '#', '#', '.', '#', '#', ' ', ' ', '#', '#', '.', '#', '#', ' ', ' ', '#', '#', '.', '#', '#' },
		{ ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '#', '#', '#', '.', '#', '#', '#', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '#', '#', '#', '#', '#', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '#', ' ', ' ', ' ', '#', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '#', ' ', ' ', ' ', '#', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '#', ' ', ' ', ' ', '#', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '#', '#', '#', '#', '#', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', '#', '#', '#', '#', '.', '#', '#', '#', '#', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ' },
		{ ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ', ' ', ' ', ' ', '#', '.', '#', ' ' },
		{ '#', '#', '.', '#', '#', ' ', ' ', '#', '#', '.', '#', '#', ' ', ' ', '#', '#', '.', '#', '#' },
		{ '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#', '#', '#', '#', '.', '.', '.', '#' },
		{ '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#', ' ', ' ', '#', '.', '.', '.', '#' },
		{ '#', '#', '#', '#', '#', ' ', ' ', '#', '#', '#', '#', '#', ' ', ' ', '#', '#', '#', '#', '#' }
	}
	-- }}}

	local f = love.graphics.setNewFont('font/PressStart2P-vaV7.ttf', 40)
	tileDimension = {
		x = f:getWidth('#'),
		y = f:getHeight('#')
	}

	tiles = {}
	for y = 1, #level do
		for x = 1, #level[y] do
			local g = level[y][x]
			local c = Coordinate:new(x * tileDimension.x, y * tileDimension.y)

			if g == ' ' then
				goto continue
			elseif g == 's' then
				g = '.'
				player = Player:new(c:clone())
			end

			local h = g == '#' and 5 or 1

			tiles[#tiles+1] = Tile:new(c:clone(), g, h)

			::continue::
		end
	end
end

function love.keypressed (key)
	player:keypressed(key)
end

function love.draw ()
	love.graphics.translate(
		love.graphics.getWidth() / 2 - player.position.x,
		love.graphics.getHeight() / 2 - player.position.y)

	for l = 0, 4 do
		for _, t in pairs(tiles) do
			t:draw(l)
		end
	end

	player:draw()
end
