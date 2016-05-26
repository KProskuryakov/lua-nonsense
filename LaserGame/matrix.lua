-- A small Matrix module for manipulating 2d arrays
local matrix = {}

-- creates a new matrix with the given dimensions
function matrix:new (o)
  o = o or {}
  o.w = o.w or 10
  o.h = o.h or 10
  o.elements = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- returns whatever is at m[x, y] or m[x] if only x is given (the matrix is 1d actually so given 6 in a 5x5 matrix will yield (1, 2))
function matrix:get (i, j)
  i = i or 1
  return self.elements[self:convertij(i, j, self.w)]
end

-- puts o into the m matrix at position x, y
function matrix:put (i, j, o)
  self.elements[self:convertij(i, j, self.w)] = o
end

-- removes whatever is at m[x, y] and replaces it with nil, returns replaced value
function matrix:remove (i, j)
  local k = self:convertij(i, j, self.w)
  local o = self.elements[k]
  self.elements[k] = nil
  return o
end

function matrix:perimeter ()
  return self.w * 2 + self.h  * 2
end

function matrix:convertij (i, j)
  return (i - 1) * w + j
end

function matrix:convertk (k)
  local i = math.floor(k / w)
  return i + 1, k - 1 % w
end

return matrix