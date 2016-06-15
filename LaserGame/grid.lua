-- inherits from Matrix
local Grid = require("matrix"):new()
local colors = require("colors")

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

-- converts the laser grid into string format for exporting
function Grid:toString ()
  local dataString = ""
  for i = 1, 25 do
    local mirror = self:get(i)
    if mirror then
      dataString = dataString .. self:get(i).index .. "\n"
    else
      dataString = dataString .. "\n"
    end
  end
  return dataString
end

local function getOppositeDirection (dir)
  if dir == "north" then
    return "south"
  elseif dir == "west" then
    return "east"
  elseif dir == "east" then
    return "west"
  elseif dir == "south" then
    return "north"
  end
  return "none"
end

-- checks whether the coordinate is an edge, returns the edge number and returns nil if not
local function checkEdge (x, y, grid)
  if y == 0 then
    return x
  elseif x == grid.w + 1 then
    return grid.w + y
  elseif y == grid.h + 1 then
    return grid.w * 2 + grid.h + 1 - x
  elseif x == 0 then
    return grid.w * 2 + grid.h * 2 + 1 - y
  else
    return nil
  end
end

-- converts the edge number to a space on the grid (only 1-20)
local function edgeToCoord (e, grid)
  if e < 1 then error("EdgeToCoord passed a negative number: " .. e) end
  if e <= grid.w then
    return e, 0, "south"
  elseif e <= grid.w + grid.h then
    return 6, e - 5, "west"
  elseif e < 16 then
    return 6 - e + 10, 6, "north"
  elseif e < 21 then
    return 0, 6 - e + 15, "east"
  end
end

return Grid