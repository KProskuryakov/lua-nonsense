local graphics = love.graphics

local window = {}
local lasergrid = {}
local mirrors = {}
local colorSwitches = {}
local paths = {}

local gridHelper = {}
local pathHelper = {}
local colorHelper = {}

function love.load ()
  if arg[#arg] == "-debug" then require("mobdebug").start() end     -- enable debug mode for ZeroBrane Studio
  graphics.setBackgroundColor(200, 200, 200)                   -- sets the background color

  lasergrid.dimensions = {width = 5, height = 5}
  for i = 1, lasergrid.dimensions.height do
    lasergrid[i] = {}
  end

  mirrors = {forwardDiag = {right = "up", left = "down", up = "right", down = "left"},
    backwardDiag = {right = "down", left = "up", up = "left", down = "right"},
    fullStop = {right = "none", left = "none", up = "none", down = "none"},
    rightSplit = {right = "none", left = "splitUpDown", up = "right", down = "right"},
    upSplit = {right = "up", left = "up", up = "none", down = "splitLeftRight"}}

  colorSwitches = {red = 1, green = 2, blue = 3}
  
  window.width, window.height = love.window.getMode()                 -- keeps the window size
  window.tilesize = 50
  window.uiGrid = {x = 0, y = 0, tileWidth = 7, tileHeight = 7}
  function window.uiGrid.processMouseInput (x, y, event, button) end
  window.uiToolbar = {x = 0, y = 500, tileWidth = 8, tileHeight = 1}
  window.components = {uiGrid, uiToolbar}

  paths = calculateAllPaths(lasergrid)
  pathHelper.printAllPaths(paths)
end

function love.update (dt)
  local mousex = love.mouse.getX()    -- mouse pos
  local mousey = love.mouse.getY()
  
  
end

function love.draw ()
end


function gridHelper.nextSpace (x, y, dir)
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

function gridHelper.getEdge (x, y, dim) 
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

function gridHelper.originToLaser (origin, dim) 
  if origin < dim.width + 1 then
    return origin, 0, "down", {0, 0, 0}
  elseif origin < dim.width + dim.height + 1 then
    return dim.width + 1, origin - dim.height, "left", {0, 0, 0}
  elseif origin < dim.width * 2 + dim.height + 1 then
    return dim.width * 2 + dim.height + 1 - origin, dim.height + 1, "up", {0, 0, 0}
  elseif origin < dim.width * 2 + dim.height * 2 + 1 then
    return 0, dim.width * 2 + dim.height * 2 + 1 - origin, "right", {0, 0, 0}
  end
end

function gridHelper.calcMirror (mirror, dir, color, colorSwitches, mirrors)
  local switch = colorSwitches[mirror]
  if switch then
    local color = {color[1], color[2], color[3]}
    color[switch] = color[switch] + 255
    return dir, color
  else
    return mirrors[mirror][dir], color
  end
end

-- PURE
function calculateAllPaths (grid)
  local paths = {}

  -- populates the path matrix with all paths' origin and endpoint
  local function calculatePath (grid, origin, dim, path, x, y, dir, color)
    for i = 1, 100 do
      x, y = gridHelper.nextSpace(x, y, dir)        -- gets the next space
      local edge = gridHelper.getEdge(x, y, dim)          -- checks if the space is an edge
      if edge then
        table.insert(path, {edge = edge, color = color})
        return path                                -- if it's an edge, terminate the path
      end

      local mirror = grid[y][x]   -- gets the mirror at the space
      if mirror then
        dir, color = gridHelper.calcMirror(mirror, dir, color, colorSwitches, mirrors)    -- gets the mirror if there is one
        if dir == "splitUpDown" then                        -- if north/south splitter
          dir = "up"                                -- this path continues north
          calculatePath(grid, origin, dim, path, x, y, "down", color)     -- calculate the path going south
        elseif dir == "splitLeftRight" then                   -- if east/west splitter
          dir = "left"                               -- this path continues east
          calculatePath(grid, origin, dim, path, x, y, "right", color)      -- calculate the path going west
        elseif dir == "none" then                  -- if terminator
          table.insert(path, {edge = "none", color = color})      -- end the path
          return path
        end
      end  -- end if mirror, continue loop
    end  -- end for loop
    table.insert(path, {edge = "loop", color = color})      -- if it's stuck in a loop, terminate the path
    return path
  end   -- end calculatePath()

  for origin = 1, 20 do  -- a path per edge
    paths[origin] = calculatePath(grid, origin, grid.dimensions, {}, gridHelper.originToLaser(origin, grid.dimensions))    -- can have multiple paths for one edge
  end
  return paths
end   -- end calculateAllPaths()


function pathHelper.pathToString (path, origin) 
  local string = origin .. " -> "
  if #path > 1 then
    string = string .. "{"
    for i = 1, #path do
      string = string .. path[i].edge .. " " .. colorHelper.getColor(path[i].color)
      if i < #path then
        string = string .. ", "
      end
    end
    string = string .. "}"
  else
    string = string .. path[1].edge .. " " .. colorHelper.getColor(path[1].color)
  end
  return string
end

function pathHelper.printAllPaths (paths)
  for i = 1, #paths do
    print(pathHelper.pathToString(paths[i], i))
  end
end


function colorHelper.getColor (color)
  if color[1] == 0 then
    if color[2] == 0 then
      if color[3] == 0 then
        return "black"
      else
        return "blue"
      end
    else
      if color[3] == 0 then
        return "green"
      else
        return "cyan"
      end
    end
  else
    if color[2] == 0 then
      if color[3] == 0 then
        return "red"
      else
        return "magenta"
      end
    else
      if color[3] == 0 then
        return "yellow"
      else
        return "white"
      end
    end
  end
end


function window.processMouseInput (x, y, event, button)
  for i = 1, #window.components do
    local component = window.components[i]
    if window.contains(x, y, component) then
      component.processMouseInput(x, y, event, button)
      return
    end
  end
end

function window.contains (x, y, component)
  return x >= component.x and x <= component.x + component.tileWidth * window.tileSize and y >= component.y and y <= component.y + component.tileHeight * window.tileSize
end