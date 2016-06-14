-- a module for storing the paths 
local paths = {}

function paths:new (o)
  o = o or {}
  o.size = o.size or 20
  o.list = o.list or {}
  setmetatable(o, self)
  self.__index = self
  return o
end




