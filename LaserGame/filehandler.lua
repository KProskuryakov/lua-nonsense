-- A small file managing module to export and import data

local FileHandler = {}

-- writes a file named file with data
function FileHandler.export (file, data)
  love.filesystem.createDirectory("exports")
  return love.filesystem.write("exports/" .. file, data)
end

function FileHandler.importGrid ()
  resetMap()
  resetMirrors()
  local i = 1
  for line in love.filesystem.lines("imports/grid.laser") do
    if line ~= "" then
      placeMirror(tonumber(line), i % 5, (i - i % 5) / 5 + 1)
    end
    i = i + 1
  end
  calculateAllPaths()
end

function FileHandler.importResults ()
end

return FileHandler