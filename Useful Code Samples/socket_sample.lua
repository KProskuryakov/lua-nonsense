-- Regular socket usage without coroutines
local socket = require "socket"
host = "www.w3.org"
file = "/TR/REC-html32.html"

local c = assert(socket.connect(host, 80))
c:send("GET " .. file .. " HTTP/1.0\r\n\r\n)"
while true do
  local s, status, partial = c:receive(2^10)
  io.write(s or partial)
  if status == "closed" then break end
end
c:close()

-- socket usage with coroutines
function download (host, file)
  local c = assert(socket.connect(host, 80))
  local count = 0   -- counts the number of bytes read
  c:send("GET " .. file .. " HTTP/1.0\r\n\r\n)"
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

