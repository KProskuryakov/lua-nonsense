local Stack = {}

function Stack:new (o)
  o = o or nil
  self.max = o.max or math.maxinteger
  setmetatable(o, self)
  self.__index = self
  return o
end

function Stack:pop ()
  local size = #self
  if size == 0 then
    return nil
  else
    local temp = self[size]
    self[size] = nil
    return temp
  end
end

function Stack:push (o)
  local size = #self + 1
  if size < self.max then
    self[size] = o
  end
end

function Stack:full ()
  return #self >= self.max
end

return Stack
