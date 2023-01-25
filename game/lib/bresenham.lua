local M = { }

local function sign(x)
	if x > 0 then
		return 1
	end

	if x < 0 then
		return -1
	end

	return 0
end

function M.line(x1, y1, x2, y2)
	local l = { }

	local dx = x2 - x1
	local dy = y2 - y1

	local incX = sign(dx)
	local incY = sign(dy)

	if dx < 0 then
		dx = -dx
	end

	if dy < 0 then
		dy = -dy
	end

	local pdx, ddx, deltaSlow, deltaFast
	if dx > dy then
		pdx = incX
		pdy = 0
		ddx = incX
		ddy = incY
		deltaSlow = dy
		deltaFast = dx
	else
		pdx = 0
		pdy = incY
		ddx = incX
		ddy = incY
		deltaSlow = dx
		deltaFast = dy
	end

	local x = x1
	local y = y1
	local err = deltaFast / 2

	l[#l+1] = {x, y}

	for i = 1, deltaFast do
		err = err - deltaSlow

		if err < 0 then
			err = err + deltaFast

			x = x + ddx
			y = y + ddy
		else
			x = x + pdx
			y = y + pdy
		end

		l[#l+1] = {x, y}
	end

	return l
end

return M
