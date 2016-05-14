-- Kostyantyn Proskuryakov
-- Feb 6, 2016
-- Programming in Lua, 3rd ED, Chapter 4

-- Exercise 4.4
-- Rewrite the state machine of Listing 4.2 (Maze)

--[[
goto room1

::room1::
do
  local move = io.read()
  if move == "south" then goto room3
  elseif move == "east" then goto room2
  else
    print("invalid move")
    goto room1
  end
end

::room2::
do
  local move = io.read()
  if move == "south" then goto room4
  elseif move == "west" then goto room1
  else
    print("invalid move")
    goto room2
  end
end

::room3::
do
  local move = io.read()
  if move == "north" then goto room1
  elseif move == "east" then goto room4
  else
    print("invalid move")
    goto room3
  end
end

::room4::
do
  print("Congratulations! You won!")
end
--]]

-- My solution using a while loop and a currentRoom state variable (as well as the hasWon variable)

local currentRoom = "room1"
local hasWon = false

while not hasWon do
  if currentRoom == "room1" then
    local move = io.read()
    if move == "south" then currentRoom = "room3"
    elseif move == "east" then currentRoom = "room2"
    else
      print("invalid move")
    end
  end

  if currentRoom == "room2" then
    local move = io.read()
    if move == "south" then currentRoom = "room4"
    elseif move == "west" then currentRoom = "room1"
    else
      print("invalid move")
    end
  end

  if currentRoom == "room3" then
    local move = io.read()
    if move == "north" then currentRoom = "room1"
    elseif move == "east" then currentRoom = "room4"
    else
      print("invalid move")
    end
  end

  if currentRoom == "room4" then
    print("Congratulations! You won!")
    hasWon = true
  end
end
