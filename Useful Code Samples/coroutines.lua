-- basic function to generate all permutations of the first n elements of a
function permgen (a, n)
  n = n or #a
  if n <= 1 then
    printResult(a)
  else
    for i = 1, n do
      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]
      
      -- generate all permutations of the other elements
      permgen(a, n - 1)
      
      -- restore i-th element
      a[n], a[i] = a[i], a[n]
    end
  end
end

function printResult(a)
  for i = 1, #a do
    io.write(a[i], " ")
  end
  io.write("\n")
end

permgen{1, 2, 3}
--[[
2 3 1 
3 2 1 
3 1 2 
1 3 2 
2 1 3 
1 2 3 
--]]

-- Time to implement coroutines!
function permgen2 (a, n)
  n = n or #a
  if n <= 1 then
    coroutine.yield(a)
  else
    for i = 1, n do
      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]
      
      -- generate all permutations of the other elements
      permgen(a, n - 1)
      
      -- restore i-th element
      a[n], a[i] = a[i], a[n]
    end
  end
end

function permutations (a)
  local co = coroutine.create(function () permgen(a) end)
  return function () -- iterator
    local code, result = coroutine.resume(co)
    return result
  end
end

for p in permutations{"a", "b", "c"} do
  printResult(p)
end

-- Could replace permutations(a) with a coroutine.wrap function
function permutations2 (a)
  return coroutine.wrap(function () permgen(a) end)
end

for p in permutations2{"d", "e", "f"} do
  printResult(p)
end
