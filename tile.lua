local class = require "middleclass"

Tile = class("Tile")

function Tile:initialize(x, y, size, solid)
  self.x = x
  self.y = y
  self.width = size
  self.height = size
  self.solid = solid or true
end

function Tile:draw(xOffset, yOffset)
  local x = self.x * self.width - xOffset
  local y = self.y * self.height - yOffset
  if(self.solid) then
    love.graphics.setColor(255,0,0,100)
  else
    love.graphics.setColor(0,255,0,100)
  end
  love.graphics.rectangle("line",x, y, self.width, self.height)
  love.graphics.print(self.x ..",".. self.y, x, y)
end

return Tile
