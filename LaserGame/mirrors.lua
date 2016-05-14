local mirrors = {       -- list of mirrors available to use
    {name = "forward-diag", mType = "mirror", north = "east", east = "north", south = "west", west = "south", x = nil, y = nil, 
      draw = function (px, py, ps)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.line(px, py + ps, px + ps, py)
      end},
    {name = "fullstop", mType = "mirror", north = "none", east = "none", south = "none", west = "none", x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.line(px, py + ps, px + ps, py)
        love.graphics.line(px, py, px + ps, py + ps)
      end},
    {name = "eastsplit", mType = "mirror", north = "east", east = "none", south = "east", west = "splitns", x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.line(px, py, px + ps/2, py + ps/2)
        love.graphics.line(px, py + ps, px + ps/2, py + ps/2)
      end},
    {name = "northsplit", mType = "mirror", north = "none", east = "north", south = "splitew", west = "north", x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.line(px, py + ps, px + ps/2, py + ps/2)
        love.graphics.line(px + ps/2, py + ps/2, px + ps, py + ps)
      end},
    {name = "backward-diag", mType = "mirror", north = "west", east = "south", south = "east", west = "north", x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.line(px, py, px + ps, py + ps)
      end},

    {name = "blue", mType = "color", red = 0, green = 0, blue = 255, x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(0, 0, 255, 255)
        love.graphics.circle("fill", px + ps/2, py + ps/2, ps/4, 10)
      end},
    {name = "green", mType = "color", red = 0, green = 255, blue = 0, x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(0, 255, 0, 255)
        love.graphics.circle("fill", px + ps/2, py + ps/2, ps/4, 10)
      end},
    {name = "red", mType = "color", red = 255, green = 0, blue = 0, x = nil, y = nil,
      draw = function (px, py, ps)
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.circle("fill", px + ps/2, py + ps/2, ps/4, 10)
      end}
  }
  
  for i, v in ipairs(mirrors) do  -- so that the mirrors know where they are in the mirrors[] table
    v.index = i
  end
  
  return mirrors