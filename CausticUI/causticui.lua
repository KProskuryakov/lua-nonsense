local CausticUI = {}

local components = {}
local graphics = nil
local window = nil
local eventHandlers = {}

function CausticUI.init (graphics, window)
  graphics = graphics
  window = window
end

function CausticUI.addEventHandler (name, handlerFunc)
  eventHandlers[name] = handlerFunc
end

function CausticUI.removeEventHandler (name)
  eventHandlers[name] = nil
end

function CausticUI.mousepressed (x, y, button, istouch)
end

function CausticUI.mousereleased (x, y, button, istouch)
end

function CausticUI.mousemoved (x, y, dx, dy)
end

function CausticUI.wheelmoved (x, y)
end

local function getComponentAtPixel (x, y)
end

return CausticUI