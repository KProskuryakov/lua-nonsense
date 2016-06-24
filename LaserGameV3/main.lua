local graphics = love.graphics

local window = {}
local lasergrid = {}
local mirrors = {}
local colorSwitches = {}


function love.load ()
  if arg[#arg] == "-debug" then require("mobdebug").start() end     -- enable debug mode for ZeroBrane Studio
  graphics.setBackgroundColor(200, 200, 200)                   -- sets the background color

  window.width, window.height = love.window.getMode()                 -- keeps the window size
  window.tilesize = 50

  lasergrid.dimensions = {width = 5, height = 5}
  for i = 1, lasergrid.dimensions.height do
    lasergrid[i] = {}
    for i = 1, lasergrid.dimensions.width do
      lasergrid[i][j] = {}
    end
  end

  mirrors = {forwardDiag = {right = "up", left = "down", up = "right", down = "left"}, 
    backwardDiag = {right = "down", left = "up", up = "left", down = "right"}, 
    fullStop = {right = "none", left = "none", up = "none", down = "none"}, 
    rightSplit = {right = "none", left = "splitUpDown", up = "right", down = "right"}, 
    upSplit = {right = "up", left = "up", up = "none", down = "splitLeftRight"}}
  colorSwitches = {red = 1, green = 2, blue = 3}
  

end

function love.update (dt)
end

function love.draw ()
end



local gridHelpers = {}

function gridHelpers.nextSpace (x, y, dir) 
  if dir == "up" then
    return x, y - 1
  elseif dir == "down" then
    return x, y + 1
  elseif dir == "left" then
    return x - 1, y
  elseif dir == "right" then
    return x + 1, y
  end
end

function gridHelpers.getEdge (x, y, dim) 
  if y == 0 then
    return x
  elseif x == dim.width + 1 then
    return dim.width + y
  elseif y == dim.height + 1 then
    return dim.width * 2 + dim.height + 1 - x
  elseif x == 0 then
    return dim.width * 2 + dim.height * 2 + 1 - y
  else
    return nil
  end
end

function gridHelpers.originToLaser (origin, dim) 
  if origin < dim.width + 1 then
    return origin, 0, "down", {0, 0, 0}
  elseif e < dim.width + dim.height + 1 then
    return {x = dim.width + 1, origin - dim.height, "left", color = {0, 0, 0}}
  elseif e < dim.width * 2 + dim.height + 1 then
    return {x = dim.width * 2 + dim.height + 1 - origin, dim.height + 1, "up", {0, 0, 0}}
  elseif e < dim.width * 2 + dim.height * 2 + 1 then
    return {x = 0, y = dim.width * 2 + dim.height * 2 + 1 - origin, "right", {0, 0, 0}}
  end
end

function gridHelpers.calcMirror (mirror, dir, color)
  local switch = colorSwitches[mirror]
  if switch then
    local color = {color[1], color[2], color[3]}
    color[switch] = color[switch] + 255
    return dir, color
  else
    return mirrors[mirror][dir], color
  end
end

function gridHelpers.getMirror (grid, x, y)
  return grid[y][x]
end


-- PURE
function calculateAllPaths (grid)
  local paths = {}

  -- populates the path matrix with all paths' origin and endpoint
  local function calculatePath (grid, origin, dim, path, x, y, dir, color)
    for i = 1, 100 do
      x, y = gridHelpers.nextSpace(x, y, dir)        -- gets the next space
      local edge = gridHelpers.getEdge(x, y, dim)          -- checks if the space is an edge
      if edge then
        table.insert(path, {edge = edge, color = color)
        return                                -- if it's an edge, terminate the path
      end

      local mirror = gridHelpers.get(grid, x, y)    -- gets the mirror at the space
      if mirror then
        dir, color = gridHelpers.calcMirror(mirror, dir, color)    -- gets the mirror if there is one
        if dir == "splitUpDown" then                        -- if north/south splitter
          dir = "up"                                -- this path continues north
          calculatePath(grid, origin, dim, path, x, y, "down", color)     -- calculate the path going south
        elseif dir == "splitLeftRight" then                   -- if east/west splitter
          dir = "left"                               -- this path continues east
          calculatePath(grid, origin, dim, path, x, y, "right", color)      -- calculate the path going west
        elseif dir == "none" then                  -- if terminator
          table.insert(path, {edge = "none", color = color})      -- end the path
          return
        end
      end  -- end if mirror, continue loop
    end  -- end for loop
    table.insert(path, {edge = "loop", color = color)      -- if it's stuck in a loop, terminate the path
  end   -- end calculatePath()
  
  
  for origin = 1, 20 do  -- a path per edge
    paths[origin] = calculatePath(grid, origin, grid.dimensions, {}, gridHelpers.originToLaser(origin, grid.dimensions))    -- can have multiple paths for one edge
  end
  return paths
end
