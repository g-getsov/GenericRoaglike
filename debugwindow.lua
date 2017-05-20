Map = require "map"

DebugWindow = {}

function DebugWindow:draw(obj)
  love.graphics.print("Player world X: " .. obj.xCoord, 0, 0)
  love.graphics.print("Player world Y: " .. obj.yCoord, 0, 15)
  love.graphics.print("World offset X: " .. Map.worldOffsetX, 0, 30)
  love.graphics.print("World offset Y: " .. Map.worldOffsetY, 0, 45)
end

return DebugWindow
