function love.load (arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end     -- enable debug mode for ZeroBrane Studio
  Matrix = require 'matrix'                                         -- get the custom Matrix module
  FileHandler = require 'filehandler'                               -- get the custom file handling mudule for imports and exports
  love.graphics.setBackgroundColor(200, 200, 200)                   -- sets the background color

  WindowWidth, WindowHeight = love.window.getMode()                 -- keeps the window size

  tilesize = 50             -- pixel width/height of each tile
  
  -- matrix that contains all mirrors within it and some more information
  -- offsetX, offsetY, currentEdge
  laserMap = Matrix:new({w = 5, h = 5})    -- creates the map matrix
  laserMap.offsetX = tilesize
  laserMap.offsetY = tilesize
  
  --[[
  The paths variable is a table that contains 20 tables representing each path
  Each table contains one or multiple strings that represent the end points of the paths
  paths = {{"15 black"}, {"2 red", "3 cyan"}, ...}
  ]]
  paths = calculateAllPaths()     -- calculates all paths from all edges
  
  --[[
  drawPathMap is a matrix in which some of the elements are nil and the others (representing the path) are
  tables that contain 1 or 2 tables representing half of a laser within each tile, a laser going in and a laser going out
  or if it's a dead end, just a laser going in
  drawPathMap = {nil, nil, {{"east", blue}, {"west", blue}}, {{"north", black}}, ...}
  ]]
  drawPathMap = Matrix:new({w = 5, h = 5})    -- creates the drawmap matrix
  
  laserMap.currentEdge = 0           -- the selected edge by the mouse to draw the path from that edge
  selectedMirror = 0        -- the mirror that the user selected in the toolbar
end   -- love.load()

-- reset the laser map
function resetMap ()
  laserMap:reset()                -- reset laser map
  drawPathMap:reset()             -- reset drawpath
  paths = calculateAllPaths()     -- calculates all paths from all edges
  
  laserMap.currentEdge = 0           -- the selected edge by the mouse to draw the path from that edge
  selectedMirror = 0        -- the mirror that the user selected in the toolbar
end

function resetMirrors ()
  for i = 1, #mirrors do
    mirrors[i].x = nil
    mirrors[i].y = nil
  end
end

function love.update (dt)
  local mousex = love.mouse.getX()    -- mouse pos
  local mousey = love.mouse.getY()

  local tilex = (mousex - mousex % tilesize) / tilesize     -- convert mouse pos to tile pos
  local tiley = (mousey - mousey % tilesize) / tilesize

  -- convert tile pos to edge number
  local newEdge                                             
  if tiley == 0 and tilex > 0 and tilex < 6 then
    newEdge = tilex
  elseif tilex == 6 and tiley > 0 and tiley < 6 then
    newEdge = tiley + 5
  elseif tiley == 6 and tilex > 0 and tilex < 6 then
    newEdge = 6 - tilex + 10
  elseif tilex == 0 and tiley > 0 and tiley < 6 then
    newEdge = 6 - tiley + 15
  else
    newEdge = 0
  end

  -- pick the edge as the new drawPath unless no edge picked
  if laserMap.currentEdge ~= newEdge then                            
    if newEdge ~= 0 then
      laserMap.currentEdge = newEdge
      drawPathMap:reset()
      calculateDrawPath(laserMap.currentEdge, nil, edgeToCoord(laserMap.currentEdge))   -- calculate the drawpath
    end
  end
end -- love.update()

function love.draw ()
  -- grid setup
  love.graphics.setColor(0, 0, 0, 130)
  for i = 0, 5 do
    love.graphics.line(tilesize, i * tilesize + tilesize, tilesize * 6, i * tilesize + tilesize)
    love.graphics.line(i * tilesize + tilesize, tilesize, i * tilesize + tilesize, tilesize * 6)
  end

  -- draw toolbar boxes
  love.graphics.line(tilesize, windowHeight - tilesize * 3, tilesize + 8 * tilesize, windowHeight - tilesize * 3)
  love.graphics.line(tilesize, windowHeight - tilesize * 2, tilesize + 8 * tilesize, windowHeight - tilesize * 2)
  for i = 0, 8 do
    love.graphics.line(tilesize + i * tilesize, windowHeight - tilesize * 3, tilesize + i * tilesize, windowHeight - tilesize * 2)
  end

  -- draw export and import buttons
  love.graphics.line(tilesize, windowHeight - tilesize, tilesize + 12 * tilesize, windowHeight - tilesize)
  love.graphics.line(tilesize * 9, windowHeight - tilesize * 2, tilesize * 13, windowHeight - tilesize * 2)
  for i = 0, 4 do
    love.graphics.line(tilesize + i * tilesize * 3, windowHeight - tilesize * 2, tilesize + i * tilesize * 3, windowHeight - tilesize)
  end
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.printf("Export Grid", tilesize, windowHeight - tilesize * 1.75, tilesize * 3, "center")
  love.graphics.printf("Export Results", tilesize + tilesize * 2, windowHeight - tilesize * 1.75, tilesize * 3 + tilesize * 2, "center")
  love.graphics.printf("Import Grid", tilesize + tilesize * 4, windowHeight - tilesize * 1.75, tilesize * 3 + tilesize * 4, "center")
  love.graphics.printf("Import Results", tilesize + tilesize * 6, windowHeight - tilesize * 1.75, tilesize * 3 + tilesize * 6, "center")

  -- draw a box around the selected mirror
  if selectedMirror ~= 0 then
    love.graphics.setColor(0, 200, 0, 120)
    love.graphics.rectangle("fill", selectedMirror * tilesize, windowHeight - tilesize * 3, tilesize, tilesize)
  end

  -- draw the mirrors on the map
  for _, v in ipairs(mirrors) do
    if v.x and v.y then
      v.draw((v.x - 1) * tilesize + laserMap.offsetX, (v.y - 1) * tilesize + laserMap.offsetY, tilesize)
    end
  end

  -- draw the mirrors in the toolbar
  for i, v in ipairs(mirrors) do
    if not v.x and not v.y then
      love.graphics.setColor(125, 0, 0, 120)
      love.graphics.rectangle("fill", i * tilesize, windowHeight - tilesize * 3, tilesize, tilesize)
    end
    v.draw(i * tilesize, windowHeight - tilesize * 3, tilesize)
  end

  -- draw the edge numbers
  love.graphics.setColor(0, 0, 0, 255)
  for i = 1, 20 do
    local x, y = edgeToCoord(i)
    love.graphics.printf(i, x * tilesize, y * tilesize + tilesize / 3, tilesize, "center")
  end

  -- write the list of current paths
  love.graphics.setColor(0, 0, 0, 255)
  for i = 1, 20 do
    if #paths[i] > 1 then
      local text = i .. " -> {"
      for j = 1, #paths[i] - 1 do
        text = text .. paths[i][j] .. ", "
      end
      text = text .. paths[i][#paths[i]] .. "}\n"
      love.graphics.printf(text, tilesize * 7, i * 15 + tilesize, tilesize * 8, "left")
    else
      love.graphics.printf(i .. " -> " .. paths[i][1] .."\n", tilesize * 7, i * 15 + tilesize, tilesize * 8, "left")
    end
  end

  -- draw the currently selected path
  for i = 1, 25 do
    local space = drawPathMap:get(i)
    if space then
      local x = (i - 1) % 5 + 1
      local y = (i - ((i - 1) % 5 + 1)) / 5 + 1
      for _, v in ipairs(space) do
        love.graphics.setColor(v.color)
        if v.dir == "north" then
          love.graphics.line(x * tilesize + tilesize / 2, y * tilesize, x * tilesize + tilesize / 2, y * tilesize + tilesize / 2)
        elseif v.dir == "east" then
          love.graphics.line(x * tilesize + tilesize / 2, y * tilesize + tilesize / 2, x * tilesize + tilesize, y * tilesize + tilesize / 2)
        elseif v.dir == "south" then
          love.graphics.line(x * tilesize + tilesize / 2, y * tilesize + tilesize / 2, x * tilesize + tilesize / 2, y * tilesize + tilesize)
        elseif v.dir == "west" then
          love.graphics.line(x * tilesize, y * tilesize + tilesize / 2, x * tilesize + tilesize / 2, y * tilesize + tilesize / 2)
        end
      end
    end 
  end
end -- end love.draw()

function love.mousepressed (x, y, b)
  -- if clicked on the toolbar, select/deselect a mirror on the toolbar
  if x > tilesize and x < tilesize * 9 and y < windowHeight - tilesize * 2 and y > windowHeight - tilesize * 3 then
    local clickedTile = pixelToTile(x, tilesize, tilesize)
    if clickedTile == selectedMirror then
      selectedMirror = 0
    else
      selectedMirror = clickedTile
    end
  end

  -- if clicked on the map
  -- TODO rewrite using placeMirror()
  if x > tilesize and x < tilesize * 6 and y > tilesize and y < tilesize * 6 then
    local tx, ty = pixelToTile(x, tilesize, tilesize), pixelToTile(y, tilesize, tilesize) -- get the tile clicked on
    local clickedMirror = laserMap:get(tx, ty)   -- get (if any) the mirror the tile contains
    if not clickedMirror and selectedMirror ~= 0 then   -- if mirror selected and the tile does not contain a mirror
      if mirrors[selectedMirror].x and mirrors[selectedMirror].y then   -- if the selected mirror is already placed
        laserMap:remove(mirrors[selectedMirror].x, mirrors[selectedMirror].y)    -- remove the placement of the selected mirror
      end
      mirrors[selectedMirror].x = tx    -- set new tile of selected mirror
      mirrors[selectedMirror].y = ty
      laserMap:put(tx, ty, mirrors[selectedMirror])    -- put the selected mirror on the map
    elseif clickedMirror then   -- if selected tile is not empty
      laserMap:remove(mirrors[clickedMirror.index].x, mirrors[clickedMirror.index].y)  -- remove the mirror from the map
      mirrors[clickedMirror.index].x = nil -- remove tile from the mirror
      mirrors[clickedMirror.index].y = nil
    end
    if clickedMirror or selectedMirror ~= 0 then -- if something on the map changed (if a mirror was clicked on or a space was clicked on while a mirror was selected)
      drawPathMap:reset()
      calculateDrawPath(laserMap.currentEdge, nil, edgeToCoord(laserMap.currentEdge))   -- recalculate drawPathMap
      calculateAllPaths()   -- recalculate all paths
    end
  end

  -- if clicked on the export/import buttons
  if x > tilesize and x < tilesize * 13 and y > windowHeight - tilesize * 2 and y < windowHeight - tilesize then
    local tx = pixelToTile(x, tilesize, tilesize * 3)
    if tx == 0 then
      FileHandler.export("grid.laser", laserGridToString(laserMap))
    elseif tx == 1 then
      FileHandler.export("results.laser", resultsToString(paths))
    elseif tx == 2 then
      FileHandler.importGrid()
    elseif tx == 3 then
      
    end
    -- TODO input actions for export grid, export results, import grid, import results
  end

end -- end love.mousepressed()

function love.quit ()   -- some debug info
  printPaths(paths)
end

-- populates the drawPath matrix with the path that needs to be drawn from an origin
function calculateDrawPath (origin, color, startx, starty, dir)
  local cx, cy = startx, starty         -- starts at an edge or a split point
  local cdir = dir
  local ccolor = color or {0, 0, 0}
  local colorText = {}
  for i = 1, 3 do
    if ccolor[i] == 0 then
      colorText[i] = "000"
    else
      colorText[i] = "255"
    end
  end

  for i = 1, 100 do
    cx, cy = nextSpace(cx, cy, cdir)    -- gets the next space
    local edge = checkEdge(cx, cy)      -- check whether the current space is an edge
    if edge then
      return                            -- if it's an edge, return right away, the drawpath is done
    end

    local mirror = laserMap:get(cx, cy)  -- returns the mirror at the spot
    drawPathMap:insert(cx, cy, {dir = getOppositeDirection(cdir), color = ccolor})   -- draw the half line coming into the space
    if mirror then                          -- if a mirror is present
      cdir, ccolor = checkMirror(mirror, cdir, ccolor)    -- get back the mirror
      if cdir == "splitns" then                           -- the mirror splits the laser north/south
        cdir = "north"
        drawPathMap:insert(cx, cy, {dir = "south", color = ccolor})
        calculateDrawPath(origin, ccolor, cx, cy, "south")                -- calculate the other path
      elseif cdir == "splitew" then                       -- the mirror splits the laser east/west
        cdir = "east"
        drawPathMap:insert(cx, cy, {dir = "west", color = ccolor})
        calculateDrawPath(origin, ccolor, cx, cy, "west")                 -- calculate the other path
      elseif cdir == "none" then                      -- if the mirror terminates the line
        break                                         -- break out, end of path
      end -- end mirror cases
    end -- end if mirror
    drawPathMap:insert(cx, cy, {dir = cdir, color = ccolor})   -- draws the second half of the line in the new cdir
  end
end   -- calculateDrawPath()



-- places mirror at specified x, y if it's empty
function placeMirror (i, x, y)
  if not laserMap:get(x, y) then
    if mirrors[i].x and mirrors[i].y then
      laserMap:remove(x, y)
    end
    mirrors[i].x = x
    mirrors[i].y = y
    laserMap:put(x, y, mirrors[i])
  end
end





-- returns the next space given the direction
function nextSpace (x, y, dir)
  if dir == "north" then
    return x, y - 1
  elseif dir == "south" then
    return x, y + 1
  elseif dir == "west" then
    return x - 1, y
  elseif dir == "east" then
    return x + 1, y
  end
end

-- prints out all of the paths
function printPaths (paths)
  for i = 1, 20 do
    if #paths[i] > 1 then
      io.write(i, " -> {")
      for j = 1, #paths[i] - 1 do
        io.write(paths[i][j], ", ")
      end
      io.write(paths[i][#paths[i]], "}\n")
    else
      io.write(i, " -> ", paths[i][1],"\n")
    end
  end
end

-- returns the tile to which a pixel corresponds to (x and y individually)
function pixelToTile (p, offset, size)
  local po = p - offset
  return (p - p % size) / size
end