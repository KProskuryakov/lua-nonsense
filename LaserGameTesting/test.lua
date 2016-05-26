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
  o.out = o.out or io.stdtout
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
  local temp = io.output()
  io.output(self.out)
  local testsRun = 0
  local testsPassed = 0
  local testsFailed = 0
  local failedTestsList = {}
  io.write("Starting ", self.name, " tests\n")
  for f, t in pairs(self.functions) do
    io.write("Test function: ", f, "\n")
    for k, v in ipairs(t) do
      testsRun = testsRun + 1
      if v.result then
        testsPassed = testsPassed + 1
        io.write("Test ", k, ": Passed\n")
      else
        testsFailed = testsFailed + 1
        io.write("Test ", k, ": Failed\n")
        table.insert(failedTestsList, {func = f, num = k, val1 = v.val1, val2 = v.val2, name = v.name})
      end
    end
  end
  io.write("Passed: ", testsPassed, "/", testsRun, "\n")
  io.write("Failed: ", testsFailed, "\n\n")
  for k, v in ipairs(failedTestsList) do
    io.write(v.func, " Test #", v.num, " ", v.name, " || Inputs: ", v.val1, ", ", v.val2, "\n")
  end
  io.output(temp)
end

function Test:equalsMargin (val1, val2, margin)
  margin = margin or 0
  self:addTest(val1, val2, val1 <= val2 + margin and val1 >= val2 - margin, "EqualsMargin")
end

function Test:equals (val1, val2)
  self:addTest(val1, val2, val1 == val2, "Equals")
end

function Test:greater (val1, val2)
  self:addTest(val1, val2, val1 > val2, "Greater")
end

function Test:greaterOrEqual (val1, val2)
  self:addTest(val1, val2, val1 >= val2, "GreaterOrEqual")
end

function Test:lesser (val1, val2)
  self:addTest(val1, val2, val1 < val2, "Lesser")
end

function Test:lesserOrEqual (val1, val2)
  self:addTest(val1, val2, val1 <= val2, "LesserOrEqual")
end

function Test:notEqual (val1, val2)
  self:addTest(val1, val2, val1 ~= val2, "NotEqual")
end

function Test:notNil (val)
  self:addTest(val, nil, val ~= nil,  "NotNil")
end

function Test:isNil (val)
  self:addTest(val, nil, val == nil, "isNil")
end

return Test