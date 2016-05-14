-- Kostyantyn Proskuryakov
-- Feb 13, 2016
-- Programming in Lua, 3rd ED, Chapter 10

-- Exercise 10.1
-- Modify the 8queens program to stop after finding the first solution
local N = 8
local finished = false
local isplaceokcalled = 0

-- check whether position (n, c) is free from attacks
local function isplaceok (a, n, c)
  isplaceokcalled = isplaceokcalled + 1
  for i = 1, n - 1 do
    if (a[i] == c) or (a[i] - i == c - n) or (a[i] + i == c + n) then
      return false
    end
  end
  return true
end

-- print a board
local function printsolution (a)
  for i = 1, N do
    for j = 1, N do
      io.write(a[i] == j and "X" or "-", " ")
    end
    io.write("\n")
  end
  io.write("\n")
end

local function addqueen (a, n)
  if n > N then
    printsolution(a)
--    finished = true
 -- elseif finished then
 --   return
  else
    for c = 1, N do
      if isplaceok(a, n, c) then
        a[n] = c
        addqueen(a, n + 1)
      end
    end
  end
end

addqueen({}, 1)
print(isplaceokcalled)