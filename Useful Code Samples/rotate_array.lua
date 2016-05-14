-- Kostyantyn Proskuryakov
-- Feb 6, 2016

-- Task: Write a function that rotates a square matrix

-- Creates a new matrix with the rotation applied
function rotateMatrix (matrix)
  newMatrix = {}
  for i = 1, #matrix do
    newMatrix[i] = {}
  end
  for k1, v1 in ipairs(matrix) do
    for k2, v2 in ipairs(v1) do
      newMatrix[k2][#matrix-k1+1] = v2
    end
  end
  return newMatrix
end

-- Modifies the given matrix by rotating it
function rotateMatrix2 (matrix)
  for i = 1, #matrix / 2 do
    for j = i, #matrix - i do
      matrix[i][j], matrix[j][#matrix - i + 1] = matrix[j][#matrix - i + 1], matrix[i][j]
      matrix[i][j], matrix[#matrix - i + 1][#matrix - j + 1] = matrix[#matrix - i + 1][#matrix - j + 1], matrix[i][j]
      matrix[i][j], matrix[#matrix - j + 1][i] = matrix[#matrix - j + 1][i], matrix[i][j]
    end
  end
end


function printMatrix (matrix)
  for _, v in ipairs(matrix) do
    print(table.unpack(v))
  end
end

local matrix = 
 {{1,2,3,4,5},
  {6,7,8,9,"a"},
  {"b","c","d","e","f"},
  {"g","h","i","j","k"},
  {"l","m","n","o","p"}}
printMatrix(matrix)
print()
printMatrix(rotateMatrix(matrix))
print()
rotateMatrix2(matrix)
printMatrix(matrix)