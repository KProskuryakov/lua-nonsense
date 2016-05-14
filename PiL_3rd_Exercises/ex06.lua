-- Kostyantyn Proskuryakov
-- Feb 7, 2016
-- Programming in Lua, 3rd ED, Chapter 6

-- Exercise 6.1
-- Write a function integral that receives a function f amd returns an approximation of its integral
function integral (f, delta)
  delta = delta or 1e-4
  return function (r1, r2)
    local result = 0
    for i = r1 + delta/2, r2 - delta/2, delta do
      result = result + f(i) * delta
    end
    return result
  end
end

do
  c = integral(math.cos)
  print(math.sin(5.2), c(0, 5.2)) --> -0.88345465572015	-0.88350150333418
  print(math.sin(math.pi/2), c(0, math.pi/2)) --> 1	0.99999999577734
end

-- Exercise 6.2
-- Write a curried version of the polynomial function
function solvePolynomial (polynomial)
  return function (x)
    local exponentiatedX = x
    local solution = polynomial[1]
    for i = 2, #polynomial do
      solution = solution + polynomial[i] * exponentiatedX
      exponentiatedX = exponentiatedX * x
    end
    return solution
  end
end

do
  c = solvePolynomial{5, 3, 1}
  print(c(2), c(5)) --> 15 45
end

-- Exercise 6.4
-- Make maze game using tail calls
function room1 ()
  local move = io.read()
  if move == "south" then return room3()
  elseif move == "east" then return room2()
  else
    print("invalid move")
    return room1()
  end
end

function room2 ()
  local move = io.read()
  if move == "south" then return room4()
  elseif move == "west" then return room1()
  else
    print("invalid move")
    return room2()
  end
end

function room3 ()
  local move = io.read()
  if move == "north" then return room1()
  elseif move == "east" then return room4()
  else
    print("invalid move")
    return room3()
  end
end

function room4 ()
  print("Congratulations! You won!")
end

room1()