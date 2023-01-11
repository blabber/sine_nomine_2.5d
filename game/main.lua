local sn = {}
sn.level = require 'sn.level'

local level

function love.load()
	love.window.setTitle('Sine Nomine 2.5D')
	love.window.setMode(
		800,
		600,
		{
			minwidth = 800,
			minheight = 600,
			resizable = true
		})
	love.keyboard.setKeyRepeat(true)

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
	if key == 'f' then
		love.window.setFullscreen(
			not love.window.getFullscreen())
		return
	elseif key == 'q' then
		if love.system.getOS() ~= "Web" then
			love.event.quit()
		end
		return
	end

	level:keypressed(key)
end

function love.draw()
	level:draw()
end
