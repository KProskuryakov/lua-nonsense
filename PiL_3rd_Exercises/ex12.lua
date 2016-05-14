-- Kostyantyn Proskuryakov
-- Feb 22, 2016
-- Programming in Lua, 3rd ED, Chapter 12

-- Exercise 12.1, 12.2 and 12.3
function serialize (o, indent)
  indent = indent or ""
  if type(o) == "number" then
    io.write(o)
  elseif type(o) == "string" then
    io.write(string.format("%q", o))
  elseif type(o) == "table" then
    io.write("{\n")
    for k, v in pairs(o) do
      if type(k) == "number" then
        io.write(indent .. "  ", k, " = ")
      elseif type(k) == "string" then
        io.write(indent .. "  ["); serialize(k); io.write("] = ")
      end
      serialize(v, indent .. "  ")
      io.write(",\n")
    end
    io.write(indent .. "}\n")
  else
    error("Cannot serialize a " .. type(o))
  end
end

serialize{5, 4, {3, 2, {a = 5, b = 6}}}