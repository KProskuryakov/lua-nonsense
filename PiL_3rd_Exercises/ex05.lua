-- Kostyantyn Proskuryakov
-- Feb 6, 2016
-- Programming in Lua, 3rd ED, Chapter 5

-- Exercise 5.1
-- Write a function that receives an arbitrary number of strings and returns them all concatenated together
function stringConcat (...)
  local stringResult = ""
  for i, v in ipairs{...} do
    stringResult = stringResult .. v
  end
  return stringResult
end

print(stringConcat("People", "are", "silly")) --> Peoplearesilly

-- Exercise 5.2
-- Write a function that prints all elements in that array
function printArray (t)
  print(table.unpack(t))
end

printArray{74, 32, "Hope", 2}  --> 74	32	Hope	2

-- Exercise 5.3
-- Write a function that receives an arbitrary number of values and
-- returns all of them but the first one
function returnAllButFirst (...)
  return table.unpack({...}, 2)
end

print(returnAllButFirst("derp", "cat", "dog", "human")) --> cat	dog	human

-- Exercise 5.4
-- Write a function that receives an array and prints all combinations of elements in the array
-- Use recursive formula C(n,m) = C(n-1,m-1) + C(n-1,m)
-- To generate all C(n,m) combinations of n elements in groups of size m,
-- first add the first element to the result and then generate all C(n-1,m-1) combinations of the 
-- remaining elements in the remaining slots, then you remove the first element
-- from the result and generate all C(n-1,m) combinations of the remaining
-- elements in the free slots. When n is smaller than m, there are no combinations.
-- When m is zero, there is only one combination, which uses no elements
function combinationsOfArray (array, groupSize, result)
  result = result or {}
  if groupSize == 0 then
    printArray(result)
    return
  end
  if #array < groupSize then return end
  if #result < 1 then
    combinationsOfArray({table.unpack(array, 2)}, groupSize - 1, {array[1]})
  else
    combinationsOfArray({table.unpack(array, 2)}, groupSize - 1, {array[1], table.unpack(result)})
  end
  combinationsOfArray({table.unpack(array, 2)}, groupSize, result)
end

function findAllCombinations (array)
  for i = #array, 1, -1 do
    combinationsOfArray(array, i)
  end
end

do
  local array = {1, 2, 3, 4, 5}
  findAllCombinations(array)
end
