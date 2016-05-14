function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  tileSize = 20
  mapwidth = 40
  mapheight = 30
  
  player = {}
  player.x = 6
  player.y = 6
  player.state = "still"
  player.nextX = 0
  player.nextY = 0
  player.transitionX = 0
  player.transitionY = 0
  
  map = {}
  map[mapwidth * 7 + 6] = "wall"
  map[mapwidth * 9 + 7] = "wall"
  map[mapwidth * 11 + 8] = "wall"
  map[mapwidth * 12 + 9] = "wall"
end

function love.update(dt)
  if player.state == "still" then
    if map[mapwidth * (player.y + 1) + player.x] ~= "wall" then
      player.nextX = player.x
      player.nextY = player.y + 1
      player.state = "falling"
    elseif love.keyboard.isDown("right") then
      player.nextX = player.x + 1
      player.nextY = player.y
      player.state = "movingright"
    elseif love.keyboard.isDown("left") then
      player.nextX = player.x - 1
      player.nextY = player.y
      player.state = "movingleft"
    end
  end
  if player.state == "movingright" then
    player.transitionX = player.transitionX + dt * 4
    if player.transitionX >= 1 then
      player.state = "still"
      player.x = player.nextX
      player.y = player.nextY
      player.transitionX = 0
      player.transitionY = 0
    end
  elseif player.state == "movingleft" then
    player.transitionX = player.transitionX - dt * 4
    if player.transitionX <= -1 then
      player.state = "still"
      player.x = player.nextX
      player.y = player.nextY
      player.transitionX = 0
      player.transitionY = 0
    end
  elseif player.state == "falling" then
    player.transitionY = player.transitionY + dt * 8
    if player.transitionY >= 1 then
      player.state = "still"
      player.x = player.nextX
      player.y = player.nextY
      player.transitionX = 0
      player.transitionY = 0
    end
  end
end

function love.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("fill", (player.x + player.transitionX) * tileSize, (player.y + player.transitionY) * tileSize, tileSize, tileSize)
  love.graphics.setColor(120,120,120)
  for k, v in pairs(map) do
    love.graphics.rectangle("fill", (k % mapwidth) * tileSize, ((k - k%mapwidth) / mapwidth) * tileSize, tileSize, tileSize)
  end
end