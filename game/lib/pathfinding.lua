local M = { }

local function toKey(x, y)
	return string.format("%d-%d", x, y)
end

function M.find(startX, startY, endX, endY, checkValid)
	checkValid = checkValid or function(_, _) return true end

	local queue =  { { startX, startY, { } } }
	local visited = { }

	local function visitNext()
		if #queue == 0 then
			return nil
		end

		local qi = table.remove(queue, 1)
		local x, y = qi[1], qi[2]
		local path = qi[3]

		if x == endX and y == endY then
			path[#path+1] = { x, y }
			return path
		end

		local k = toKey(x, y)
		if visited[k] then
			return visitNext()
		end
		visited[k] = true

		local ds = {
			{ -1,  0 },
			{  1,  0 },
			{  0, -1 },
			{  0,  1 }
		}

		while #ds >= 1 do
			local d =
				table.remove(ds, math.random(#ds))

			local tx = x - d[1]
			local ty = y - d[2]

			if checkValid(tx, ty) then
				local tp = { }
				for _, v in ipairs(path) do
					tp[#tp+1] = { v[1], v[2] }
				end
				tp[#tp+1] = { x, y }

				queue[#queue+1] = { tx, ty, tp }
			end
		end

		return visitNext()
	end

	return visitNext()
end

return M
