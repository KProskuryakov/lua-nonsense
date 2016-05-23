local Test = require "LaserGameTesting.test"
local Matrix = Test.getModule "LaserGame.matrix"
local tester = Test:new()

local function TestFunction1 ()
  tester:setFunction "TestFunction1"
  local testMatrix1 = Matrix:new{w = 5, h = 5}
  
  tester:equals(testMatrix1.w, 5)
  tester:equals(4, 5)
end


TestFunction1()
tester:runTests()