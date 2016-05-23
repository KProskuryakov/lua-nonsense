local Game = {}

function Game.load()
  Game.grid = Matrix:new{w = 5, h = 5}
  
  -- {string name, string mType, string north, string east, string south, string west, num x, num y, function draw(px, py, ps), num index}
  Game.mirrors = require 'mirrors'
end

-- function to iterate through all 20 edges and get their paths, populates the paths list
function Game.calculateAllPaths (grid)
  paths = {}
  for i = 1, 20 do  -- a path per edge
    paths[i] = {}
    calculatePath(i, paths, nil, edgeToCoord(i))    -- can have multiple paths for one edge
  end
  return paths
end

-- populates the path matrix with all paths' origin and endpoint
function calculatePath (origin, paths, color, startx, starty, dir)
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

    local mirror = laserMap:get(cx, cy)    -- gets the mirror at the space
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
end   -- end calculatePath()



return Game