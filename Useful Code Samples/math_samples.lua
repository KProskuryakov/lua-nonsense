-- This file contains some useful math and logic shortcuts in lua

-- Truncate to integer or decimals
do
  local x = math.pi
  print(x - x%0.01)   --> 3.14
  print(x - x%1)      --> 3
  x = 163423
  print(x - x%100)    --> 163400
end

-- Wrapping angles to be in the [0, 360] or [0, 2pi] ranges
print(150 % 360)                    --> 150
print(400 % 360)                    --> 40
print(-50 % 360)                    --> 310
print((-math.pi/2) % (2*math.pi))   --> 3pi/2

-- If (condition) then value1 else value2
do
  local x = 5; local y = 2; 
  local max = (x > y) and x or y
  local min = (x < y) and x or y
  print(max) --> 5
  print(min) --> 2
end

-- Assignment swapping (THANK YOU)
do
  local x, y = 3, 5   -- initializes multiple local variables
  x, y = y, x   -- swaps x and y (in 1 line)
  print(x,y)
end

-- Reverse Tables, useful for finding the ID of an item based on it's name
do
  local days = {"Sunday", "Monday", "Tuesday", "Wednesday", 
                "Thursday", "Friday", "Saturday"}
  local revDays = {}
  for k,v in pairs(days) do
    revDays[v] = k
  end
end

-- table.unpack returns all table values as seperate arguments
-- notice the {} notation for the unpack function. If the parameter
-- is just a table constructor or literal string, you don't need ()
do
  print(table.unpack{10,20,30}) --> 10  20  30
  print(table.unpack({10, 20, 30, 40, 50}, 2, 3)) --> 20  30
end

-- The variadic identity function. Only functions at the end of a list
-- are able to return all of their results. The rest will return only the first
function id (...) return ... end
print(id(table.unpack{"5", 3}, "Excalibur", table.unpack{"Tentacruel", 4, "The Rock"}))  --> 5	Excalibur	Tentacruel	4	The Rock

-- A format and write function, merging the two together and showcasing ... some more
function fwrite (fmt, ...)
  return io.write(string.format(fmt, ...))
end
fwrite("%d%d", 4, 5) --> 45
print()

-- Testing local functions
local thing = 1
local thingTester = function (x)
  if thing < x then
    print(thing)
    thing = thing + 1
    return thingTester(x)
  else
    print("done")
  end
end
thingTester(5)