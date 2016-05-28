local Test = require "test"
local Stack = require "stack"

local tester = Test:new{name = "stacktester"}

local function TestFunction1 ()
  tester:setFunction "TestFunction1"
  local stack = Stack:new{max = 5}
  tester:equals(stack.max, 5)
  
  stack:push(10)
  tester:equals(stack[1], 10)
  
  tester:equals(stack:pop(), 10)
  tester:equals(#stack, 0)
  tester:equals(stack:pop(), nil)
end

TestFunction1()
tester:runTests()