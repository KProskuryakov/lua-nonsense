-- inherits from Matrix
local Grid = require("matrix"):new()

function Grid:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Grid:calculatePaths ()
  local paths = {}
  for i = 1, self:perimeter() do  -- a path per edge
    paths[i] = {}
    self:calculatePath(i, paths, nil, edgeToCoord(i))    -- can have multiple paths for one edge
  end
  return paths
end

function Grid:calculatePath (edge, paths, color, startx, starty, dir)
  local cx, cy = startx, starty
  local cdir = dir
  local ccolor = color or {0, 0, 0}

  for i = 1, 100 do
    cx, cy = nextSpace(cx, cy, cdir)        -- gets the next space
    local edge = checkEdge(cx, cy)          -- checks if the space is an edge
    if edge then
      table.insert(paths[origin], edge .. " " .. colorToString(ccolor))
      return                                -- if it's an edge, terminate the path
    end

    local mirror = self:get(cx, cy)    -- gets the mirror at the space
    if mirror then
      cdir, ccolor = checkMirror(mirror, cdir, ccolor)    -- gets the mirror if there is one
      if cdir == "splitns" then                        -- if north/south splitter
        cdir = "north"                                -- this path continues north
        calculatePath(origin, paths, ccolor, cx, cy, "south")     -- calculate the path going south
      elseif cdir == "splitew" then                   -- if east/west splitter
        cdir = "east"                               -- this path continues east
        calculatePath(origin, paths, ccolor, cx, cy, "west")      -- calculate the path going west
      elseif cdir == "none" then                  -- if terminator
        table.insert(paths[origin], "end")      -- end the path
        return
      end
    end  -- end if mirror, continue loop
  end  -- end for loop
  table.insert(paths[origin], "loop")      -- if it's stuck in a loop, terminate the path
end

return Grid