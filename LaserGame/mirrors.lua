local mirrors = {       -- list of mirrors available to use
  ForwardDiag = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.line(px, py + ps, px + ps, py)
    end,
    processLaser = function (direction, color)
      if direction == "north" then return "east", color end
      if direction == "east" then return "north", color end
      if direction == "south" then return "west", color end
      if direction == "west" then return "south", color end
    end
  },
  
  FullStop = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.line(px, py + ps, px + ps, py)
      love.graphics.line(px, py, px + ps, py + ps)
    end,
    processLaser = function (direction, color)
      return "none", color
    end
  },
  
  EastSplit = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.line(px, py, px + ps/2, py + ps/2)
      love.graphics.line(px, py + ps, px + ps/2, py + ps/2)
    end,
    processLaser = function (direction, color)
      if direction == "north" then return "east", color end
      if direction == "east" then return "none", color end
      if direction == "south" then return "east", color end
      if direction == "west" then return "splitns", color end
    end
  },
  
  NorthSplit = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.line(px, py + ps, px + ps/2, py + ps/2)
      love.graphics.line(px + ps/2, py + ps/2, px + ps, py + ps)
    end,
    processLaser = function (direction, color)
      if direction == "north" then return "none", color end
      if direction == "east" then return "north", color end
      if direction == "south" then return "splitew", color end
      if direction == "west" then return "north", color end
    end
  },
  
  BackwardDiag = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.line(px, py, px + ps, py + ps)
    end,
    processLaser = function (direction, color)
      if direction == "north" then return "west", color end
      if direction == "east" then return "south", color end
      if direction == "south" then return "east", color end
      if direction == "west" then return "north", color end
    end
  },

  Blue = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 0, 255, 255)
      love.graphics.circle("fill", px + ps/2, py + ps/2, ps/4, 10)
    end,
    processLaser = function (direction, color)
      return direction, {color[1], color[2], 255}
    end
  },
  
  Green = {
    draw = function (px, py, ps)
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.circle("fill", px + ps/2, py + ps/2, ps/4, 10)
    end,
    processLaser = function (direction, color)
      return direction, {color[1], green, color[3]}
    end
  },
  
  Red = {
    draw = function (px, py, ps)
      love.graphics.setColor(255, 0, 0, 255)
      love.graphics.circle("fill", px + ps/2, py + ps/2, ps/4, 10)
    end,
    processLaser = function (direction, color)
      return direction, {255, color[2], color[3]}
    end
  }
}
  
for i, v in ipairs(mirrors) do  -- so that the mirrors know where they are in the mirrors[] table
  v.index = i
end

return mirrors