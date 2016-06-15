local Location = {}

function Location:new (o)
  o.x = o.x or 0
  o.y = o.y or 0
  o.dir = o.dir or "none"
  setmetatable(o, self)
  self.__index = self
  return o
end

function Location:getOppositeDirection ()
  if self.dir == "north" then
    return "south"
  elseif self.dir == "west" then
    return "east"
  elseif self.dir == "east" then
    return "west"
  elseif self.dir == "south" then
    return "north"
  end
  return "none"
end