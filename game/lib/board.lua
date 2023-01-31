local M = { }

local Board = { }

function M.new(width)
	local b = {
		_width = width,
		_data = { }
	}
	
	Board.__index = Board
	setmetatable(b, Board)
	
	return b
end

function Board:_indexToPosition(index)
	local x = (index - 1) % self._width + 1
	local y = (index - 1) / self._width + 1
	
	return x, math.floor(y)
end

function Board:_positionToIndex(x, y)
	return (y - 1) * self._width + x
end

function Board:get(x, y)
	return self._data[self:_positionToIndex(x, y)]
end

function Board:set(x, y, value)
	self._data[self:_positionToIndex(x, y)] = value
end

function Board:iterate()
	local is = { }
	for i in pairs(self._data) do
		is[#is+1] = i
	end

	local i = 0
	local function f(state)
		i = i + 1
		local v = state._data[is[i]]

		if v == nil then
			return nil
		end

		local x, y = state:_indexToPosition(is[i])

		return v, x, y
	end

	return f, self, true
end

return M
