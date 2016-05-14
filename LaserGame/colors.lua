local colors = {}
colors.getColor = function (color)
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

return colors