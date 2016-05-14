-- Kostyantyn Proskuryakov
-- Feb 10, 2016
-- Programming in Lua, 3rd ED, Chapter 8

-- Exercise 8.1
-- Write a function loadwithprefix(), it should call load() with a 
-- proper reader function that first returns the prefix and then 
-- returns the original chunk
function loadwithprefix (p, f)
  local i = "start"
  local iter = function ()
    if i == "start" then
      i = (type(f) == "function") and "function" or "string"
      return p
    elseif i == "string" then
      i = "done"
      return f
    elseif i == "function" then
      return f()
    else
      return nil
    end
  end
  return load(iter)
end

loadwithprefix("print('Hello')", io.lines("PiL_3rd_Exercises\\ex8temp.txt", "*L"))()
print()


-- Exercise 8.2
-- Write a function multiload that can take any number of strings or readers
-- and load a chunk of code from all of that
function multiload (...)
  local i = 1
  local params = {...}
  local curType = "unknown"
  
  local function iter ()
    local param = params[i]
    if i > #params then
      return nil
    elseif curType == "unknown" then
      if type(param) == "function" then
        curType = "function"
        return param()
      else
        i = i + 1
        return param
      end
    elseif curType == "function" then
      local result = param()
      if result then 
        return result
      else
        curType = "unknown"
        i = i + 1
        return iter()
      end
    end
  end
  
  return load(iter)
end

multiload("print('welcome')", io.lines("PiL_3rd_Exercises\\ex8temp.txt", "*L"), "print('goodbye')")()
print()
multiload("print('welcome')", "print('goodbye')", io.lines("PiL_3rd_Exercises\\ex8temp.txt", "*L"), io.lines("PiL_3rd_Exercises\\ex8temp.txt", "*L"))()

-- Exercise 8.3
-- stringrep, uses binary multiplaction to concatenate n copies of a given string s
-- Write a function that returns a specialized function stringrep_n. Build the
-- text of the function using load. Then compare performance
function stringrep (s, n)
  local r = ""
  if n > 0 then
    while n > 1 do
      if n % 2 ~= 0 then r = r .. s end
      s = s .. s
      n = math.floor(n / 2)
    end
    r = r .. s
  end
  return r
end

-- my function
function mystringrep (s, n)
  local state = "start"
  
  local function iter ()
    if state == "done" then
      return nil
    end
    
    if state == "start" then
      state = "middle"
      return "local s = \"" .. s .. "\"; local r = \"\";"
    elseif n > 1 then
      if n % 2 ~= 0 then 
        n = math.floor(n / 2)
        return "r = r .. s; s = s .. s;" 
      end
      n = math.floor(n / 2)
      return "s = s .. s;"
    elseif n <= 1 then
      state = "done"
      return "r = r .. s; return r"
    end
  end
  
  return load(iter)
end

print(stringrep("d", 7))
print(mystringrep("d", 7)())

