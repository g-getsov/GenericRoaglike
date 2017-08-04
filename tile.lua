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
  local x = self:getX() - xOffset
  local y = self:getY() - yOffset
  if(self.solid) then
    love.graphics.setColor(255,0,0,255)
  else
    love.graphics.setColor(0,255,0,30)
  end
  love.graphics.rectangle("line",x, y, self.width, self.height)
end

function Tile:getX() return self.x * self.width end
function Tile:getY() return self.y * self.height end
function Tile:getXUnitPosition() return self.x end
function Tile:getYUnitPosition() return self.y end
function Tile:getWidth() return self.width end
function Tile:getHeight() return self.height end

return Tile
