function love.load (arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end     -- enable debug mode for ZeroBrane Studio
  Game = require('game')
  UI = require('ui')
  Game.load()
  UI.load()
end

function love.update (dt)
  Game.update(dt)
end

function love.draw ()
  UI.draw (love.graphics)
end

function love.mousepressed (x, y, b)
  UI.processInput(x, y, b)
end

function love.quit ()
end