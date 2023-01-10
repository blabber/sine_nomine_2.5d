local sn = {}
sn.level = require 'sn.level'

local level

function love.load()
	local f = love.graphics.setNewFont('font/PressStart2P-vaV7.ttf', 40)
	level = sn.level.fromString(f, [[
#####  #####  #####
#...#  #...#  #...#
#...####...####...#
#.s...............#
#...####...####...#
#...#  #...#  #...#
##.##  ##.##  ##.##
 #.#    #.#    #.# 
 #.#    #.#    #.# 
 #.#    #.#    #.# 
 #.# ####.#### #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.#####.# #.# 
 #.# #.#   #.# #.# 
 #.# #.#   #.# #.# 
 #.# #.#   #.# #.# 
 #.# #.#####.# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# #.......# #.# 
 #.# ####.#### #.# 
 #.#    #.#    #.# 
 #.#    #.#    #.# 
 #.#    #.#    #.# 
##.##  ##.##  ##.##
#...#  #...#  #...#
#...####...####...#
#.................#
#...####...####...#
#...#  #...#  #...#
#####  #####  #####
]])
end

function love.update(deltaTime)
	level:update(deltaTime)
end

function love.keypressed(key)
	level:keypressed(key)
end

function love.mousepressed(x, y)
	local a = math.deg(
		math.atan2(
			y - love.graphics.getHeight() / 2,
			x - love.graphics.getWidth() / 2))

	if a < 0 then
		a = a + 360
	end

	if (a > 45) and (a <= 135) then
		level:keypressed("down")
	elseif (a > 135) and (a <= 225) then
		level:keypressed("left")
	elseif (a > 225) and (a <= 315) then
		level:keypressed("up")
	else
		level:keypressed("right")
	end
end

function love.touchpressed(_, x, y)
	love.mousepressed(x, y)
end

function love.draw()
	level:draw()
end
