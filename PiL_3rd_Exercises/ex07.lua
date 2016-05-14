-- Kostyantyn Proskuryakov
-- Feb 8, 2016
-- Programming in Lua, 3rd ED, Chapter 7

-- Exercise 7.1
--[[
Write an iterator fromto such that the next two loops become equivalent
for i in fromto(n, m)
  <body>
end

for i = n, m
  <body>
end

Try to implement it as a stateless iterator
--]]

function fromto (n, m, step)
  local function iter (m, i) 
    i = i + 1
    if i > m then
      return nil
    else
      return i
    end
  end
  
  return iter, m, n - 1
end

for i in fromto(3, 6) do
  print(i) --> 3 4 5 6
end

for i = 3, 6 do
  print(i) --> 3 4 5 6
end

-- Exercise 7.2
-- Add a step parameter to the previous exercise
-- Is it possible to do it as stateless?
function fromto2 (n, m, step)
  local i = n - step
  return function ()
    i = i + step
    if i > m then
      return nil
    else
      return i
    end
  end
end

for i in fromto2(3, 10, 2) do
  print(i)  --> 3 5 7 9
end

-- Exercise 7.3
-- Write an iterator uniquewords that returns all words from a given file without repetitions. (Hint, start with allwords code in listing 7.1; use a table to keep all words already reported
function uniquewords ()
  local line = io.read()
  local pos = 1
  local words = {}
  return function ()
    while line do
      local s, e = string.find(line, "%w+", pos)
      if s then
        pos = e + 1
        local word = string.sub(line, s, e)
        if not words[word] then
          words[word] = true
          return word
        end        
      else
        line = io.read()
        pos = 1
      end -- end if s 
    end -- end while line
    return nil
  end -- end iterator
end

--[[
for word in uniquewords() do
  print(word)
end
--]]

-- Exercise 7.4
-- Write an iterator that returns all non-empty substrings of a given string (using string.sub())
function substrings (s)
  local start = 1
  local pos = 0
  return function ()
    if start <= #s then
      if pos < #s then
        pos = pos + 1
      else
        start = start + 1
        pos = start
      end
      return string.sub(s, start, pos)
    else
      return nil
    end
  end
end

for sub in substrings("1234567") do
  print(sub)
end
