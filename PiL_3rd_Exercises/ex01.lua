-- Kostyantyn Proskuryakov
-- Feb 5, 2016
-- Programming in Lua, 3rd ED, Chapter 1

-- Exercise 1.1

--[[
-- The factorial function that the book gave
function fact (n)
  if n == 0 then
    return 1
  else
    return n * fact(n-1)
  end
end --]]

-- My modified factorial function with negative number handling
function fact (n)
  if n < 0 then
    return "Input must be a positive number"
  elseif n == 0 then
    return 1
  else
    return n * fact(n-1)
  end
end

print("enter a number:")
a = io.read("*n")
print(fact(a))

--[[
Run 1:
5 -> 120

Run 2:
-1 -> Stack Overflow

Fixing error...

Run 3:
-1 -> Input must be a positive number
--]]