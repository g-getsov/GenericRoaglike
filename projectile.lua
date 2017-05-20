local class = require "middleclass"
local directions = require "directions"
local Map = require "map"

Projectile = class("Projectile")

function Projectile:initialize(x, y, speed, radius, damage)
  self.x = x or 0
  self.y = y or 0
  self.dx = 0
  self.dy = 0
  self.radius = radius or 5
  self.speed = speed or 0
  self.damage = damage or 1
end

function Projectile:interact(obj)
  obj.health = obj.health - self.damage
end

function Projectile:draw()
  love.graphics.circle("fill", self.x - Map.worldOffsetX, self.y - Map.worldOffsetY, self.radius)
  love.graphics.setColor(255,0,0,255)
end

return Projectile
