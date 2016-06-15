-- a module for computing paths
local paths = {}

function paths.toString (paths)
  returnString = ""
  for i = 1, 20 do
    if #paths[i] > 1 then
      returnString = returnString .. i .. " -> {"
      for j = 1, #paths[i] - 1 do
        returnString = returnString .. paths[i][j] .. ", "
      end
      returnString = returnString .. paths[i][#paths[i]] .. "}\n"
    else
      io.write(i, " -> ", paths[i][1],"\n")
      returnString = returnString .. i .. " -> " .. paths[i][1] .. "\n"
    end
  end
  return returnString
end


