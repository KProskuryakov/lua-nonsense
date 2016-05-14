-- Kostyantyn Proskuryakov
-- Feb 5, 2016
-- Programming in Lua, 3rd ED, Chapter 3

-- Exercise 3.2
print(2^3^4)        --> 2.4178516392293e+024
print(2^-3^4)       --> (2^(-81)) --> 4.1359030627651e-025

-- Exercise 3.3
-- Write a function that receives a polynomial as a table and a value for x and returns the polynomial value
-- Polynomial received as {a0,a1,...,an)
function solvePolynomial (polynomial, x)
  local solution = polynomial[1]
  for i = 2, #polynomial do
    solution = solution + polynomial[i] * x^(i-1)
  end
  return solution
end

print(solvePolynomial({5,3,1},2)) --> 15
print(solvePolynomial({-1,-3,7,3,1,3,2},3)) --> 2402

-- Exercise 3.4
-- Same as 3.3 but the function has to do n additions and n multiplications and no exponentiations
-- My solution is 2n multiplications, n additions and no exponentiations
function solvePolynomial2 (polynomial, x)
  local exponentiatedX = x
  local solution = polynomial[1]
  for i = 2, #polynomial do
    solution = solution + polynomial[i] * exponentiatedX
    exponentiatedX = exponentiatedX * x
  end
  return solution
end

print(solvePolynomial2({5,3,1},2)) --> 15
print(solvePolynomial2({-1,-3,7,3,1,3,2},3)) --> 2402

-- Exercise 3.5
-- How can you check a boolean type without using typeof
function booleanChecker (b)
  return b == true or b == false
end

print(booleanChecker(true))     --> true
print(booleanChecker(false))    --> true
print(booleanChecker(nil))      --> false
print(booleanChecker("Hello"))  --> false
print(booleanChecker(5))        --> false
print(booleanChecker(0))        --> false
print(booleanChecker(-3))       --> false

-- Exercise 3.7
-- What will the script print?
sunday = "monday"; monday = "sunday"
t = {sunday = "monday", monday = "sunday"}
print(t.sunday, t[sunday], t[t.sunday]) --> monday  sunday  sunday

-- Exercise 3.8
-- Create a table constructor that associates escape sequences for strings with their meaning
escapeTable = {
  ["\n"] = "new line",
  ["\\"] = "backslash",
  ["\""] = "double quote"
}

print(escapeTable[""], escapeTable["\""], escapeTable["\\"])