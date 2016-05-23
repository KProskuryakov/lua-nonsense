local Test = {}

function Test.getModule (moduleName)
  local path = package.path
  package.path = ";../?.lua" .. package.path 
  local mod = require(moduleName)
  package.path = path
  return mod
end

function Test:new (o)
  o = o or {}
  o.name = o.name or "default"
  o.curfunc = o.curfunc or "testmethod"
  o.functions = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Test:setFunction (func)
  self.curfunc = func
end

function Test:addTest(val1, val2, result, name)
  self.functions[self.curfunc] = self.functions[self.curfunc] or {}
  table.insert(self.functions[self.curfunc], {val1 = val1, val2 = val2, result = result, name = name})
end

function Test:runTests ()
  local testsRun = 0
  local testsPassed = 0
  local testsFailed = 0
  local failedTestsList = {}
  print("Starting " .. self.name .. " tests")
  for f, t in pairs(self.functions) do
    print("Test method: " .. m)
    for k, v in ipairs(t) do
      testsRun = testsRun + 1
      if v.result then
        testsPassed = testsPassed + 1
        print("Test " .. k .. ": Passed")
      else
        testsFailed = testsFailed + 1
        print("Test " .. k .. ": Failed")
        table.insert(failedTestsList, {func = f, num = k, val1 = v.val1, val2 = v.val2, name = v.name})
      end
    end
  end
  print("Passed: " .. testsPassed .. "/" .. testsRun)
  print("Failed: " .. testsFailed .. "\n")
  for k, v in ipairs(failedTestsList) do
    print(v.func .. " Test #" .. v.num .. " " .. v.name .. " || Inputs: " .. v.val1 .. ", " .. v.val2)
  end
end

function Test:equalsMargin(val1, val2, margin)
  margin = margin or 0
  self:addTest(val1, val2, val1 <= val2 + margin and val1 >= val2 - margin, "EqualsMargin")
end

function Test:equals(val1, val2)
  self:addTest(val1, val2, val1 == val2, "Equals")
end

return Test