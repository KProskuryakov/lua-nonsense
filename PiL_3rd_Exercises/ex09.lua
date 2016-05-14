-- Kostyantyn Proskuryakov
-- Feb 12, 2016
-- Programming in Lua, 3rd ED, Chapter 9 PART 1

-- Exercise 9.1
-- Use coroutines to transform the function in exercise 5.4 into a generator for combinations, to be used like here:
--[[
for c in combinations({"a", "b", "c"}, 2) do
  printResult(c)
end
--]]
function combinationsOfArray (array, groupSize, result)
  result = result or {}
  if groupSize == 0 then
    coroutine.yield(result)
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

function combinations (array, groupSize)
  return coroutine.wrap(function () combinationsOfArray(array, groupSize) end)
end

function printArray (t)
  print(table.unpack(t))
end

for c in combinations({"a", "b", "c"}, 2) do
  printArray(c)
end


-- Exercise 9.2
-- Implement and run the code below
local socket = require "socket"

function download (host, file)
  local c = assert(socket.connect(host, 80))
  local count = 0
  c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
  while true do
    local s, status = receive(c)
    count = count + #s
    if status == "closed" then break end
  end
  c:close()
  print(file, count)
end

function receive (connection)
  connection:settimeout(0)
  local s, status, partial = connection:receive(2^10)
  if status == "timeout" then
    coroutine.yield(connection)
  end
  return s or partial, status
end

-- Dispatcher
threads = {}

function get (host, file)
  -- create coroutine
  local co = coroutine.create(function ()
    download(host, file)
  end)
  -- insert into list
  table.insert(threads, co)
end

--[[
-- this function uses a lot of cpu, better to use the next one with socket.select()
function dispatch ()
  local i = 1
  while true do
    if threads[i] == nil then   -- no more threads?
      if threads[1] == nil then break end -- list is empty?
      i = 1                     -- restart loop
    end
    local status, res = coroutine.resume(threads[i])
    if not res then       -- thread finished its task?
      table.remove(threads, i)
    else
      i = i + 1           -- go to next thread
    end
  end
end
--]]

function dispatch ()
  local i = 1
  local timedout = {}
  while true do
    if threads[i] == nil then   -- no more threads?
      if threads[1] == nil then break end -- list is empty?
      i = 1                     -- restart loop
      timedout = {}
    end
    local status, res = coroutine.resume(threads[i])
    if not res then       -- thread finished its task?
      table.remove(threads, i)
    else
      i = i + 1           -- go to next thread
      timedout[#timedout + 1] = res
      if #timedout == #threads then      -- all threads blocked?
        socket.select(timedout)
      end
    end
  end
end

-- test
host = "www.w3.org"

get(host, "/TR/html401/html40.txt")
get(host, "/TR/2002/REC-xhtml1-20020801/xhtml1.pdf")
get(host, "/TR/REC-html32.html")

dispatch()