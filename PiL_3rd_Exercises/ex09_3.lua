-- Kostyantyn Proskuryakov
-- Feb 12, 2016
-- Programming in Lua, 3rd ED, Chapter 9 PART 2

-- Exercise 9.3
-- Implement a transfer function in Lua. If you think about resume-yield as 
-- similar to call-return, a transfer would be like a goto: it suspends
-- the running coroutine and resumes any other coroutine, given as an argument.
-- (Hint: use a kind of dispatch to control your subroutines. Then, a transfer 
-- would yield to the dispatch signaling the next coroutine to run, and the 
-- dispatch would resume that next coroutine.

function transfer (co, result)
  coroutine.yield(co, result)
end

function dispatch (startingco)
  local co = startingco
  while true do
    local status, newco, res = coroutine.resume(co)
    co = newco
    print(res)
    if res == "terminate" then break end
  end
end

co1 = coroutine.create(function ()
    transfer(co2, 1)
  end
)

co2 = coroutine.create(function ()
    transfer(co3, 2)
  end
)

co3 = coroutine.create(function ()
    transfer(nil, "terminate")
  end
)

dispatch(co1)
