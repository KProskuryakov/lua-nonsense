-- A small Matrix module for manipulating 2d arrays
local matrix = {}

-- creates a new matrix with the given dimensions
function matrix:new (o)
  o = o or {}
  o.w = o.w or 10
  o.h = o.h or 10
  setmetatable(o, self)
  self.__index = self
  return o
end

-- returns whatever is at m[x, y] or m[x] if only x is given (the matrix is 1d actually so given 6 in a 5x5 matrix will yield (1, 2))
function matrix:get (x, y)
  y = y or 1
  return self[(y - 1) * self.w + x]
end

-- puts o into the m matrix at position x, y
function matrix:put (x, y, o)
  self[(y - 1) * self.w + x] = o
end

-- inserts o into the table that is contained in m[x, y]
function matrix:insert (x, y, o)
  if self[(y - 1) * self.w + x] == nil then
    self[(y - 1) * self.w + x] = {}
  end
  table.insert(self[(y - 1) * self.w + x], o)
end

-- removes whatever is at m[x, y] and replaces it with nil, returns replaced value
function matrix:removeAt (x, y)
  local i = (y - 1) * self.w + x
  local o = self[i]
  self[i] = nil
  return o
end

function matrix:removeObj (o)
  for element in pairs(self)

function matrix:perimeter ()
  return self.w * 2 + self.h  * 2
end

return matrix