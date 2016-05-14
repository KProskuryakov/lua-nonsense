-- Kostyantyn Proskuryakov
-- Feb 5, 2016
-- Programming in Lua, 3rd ED, Chapter 2

-- Exercise 2.6

a = {}; a.a = a
print(a.a.a.a) --> table address
a.a.a.a = 4 -- basically sets a.a to 4.
print(a.a) --> 4
print(a) --> table address