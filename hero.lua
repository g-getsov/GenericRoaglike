local class = require "middleclass"
local directions = require "directions"
local Weapon = require "weapon"
local DebugWindow = require "debugwindow"
local mousebuttons = require "mousebuttons"

Hero = class("Hero")

function Hero:initialize(x, y, width, height, speed, direction)
  self.x = x or 0
  self.y = y or 0
  self.width = width or 50
  self.height = height or 50
  self.speed = speed or 100
  self.direction = direction or directions.down
  self.weapon = Weapon:new();
  self.shots = {}
  self.debugMode = false
end

function Hero:shoot(targetX, targetY)
  
  local weapon = self.weapon
  
  local projectile = weapon:fire(
    self.x + self.width/2,
    self.y,
    targetX,
    targetY
  )
  
  if projectile == nil then
    return
  end
  
  table.insert(self.shots, projectile)
end

function Hero:update(deltaTime)
  self:input(deltaTime)
  self.weapon:update(deltaTime)
end

function Hero:input(deltaTime)
  
  if love.keyboard.isDown("left") 
  or love.keyboard.isDown("a") 
  then
    self.x = self.x - self.speed*deltaTime
    self.direction = directions.left
  end
    
  if love.keyboard.isDown("right") 
  or love.keyboard.isDown("d")
  then
    self.x = self.x + self.speed*deltaTime
    self.direction = directions.right
  end
  
  if love.keyboard.isDown("up") 
  or love.keyboard.isDown("w") 
  then
    self.y = self.y - self.speed*deltaTime
    self.direction = directions.up
  end
  
  if love.keyboard.isDown("down")
  or love.keyboard.isDown("s") 
  then
    self.y = self.y + self.speed*deltaTime
    self.direction = directions.down
  end
  
  function love.keyreleased(key)
    if key == "r" then
      self.weapon:reload()
    elseif key == "1" then
      self.debugMode = not self.debugMode
    end
  end
  
  function love.mousepressed(x, y, button)
    
    if button == mousebuttons.left then
      self:shoot(x, y)
    end
end
  
end

function Hero:draw()
  
  love.graphics.setColor(50,50,50,255)
  love.graphics.rectangle(
    "fill",
    self.x,
    self.y,
    self.width,
    self.height
  )
  
  self:drawWeaponStats()
  
  if(self.debugMode) then
    self:drawDebugWindow()
  end
end

function Hero:drawWeaponStats()
  
  reloadTimeLeft = self.weapon.reloadTimeLeft
  
  ammoStatus = self.weapon.magazine.remaining .. "/" .. self.weapon.magazine.capacity
  
  love.graphics.print(
      ammoStatus,
      self.x,
      self.y - 20
    )
  
  if (reloadTimeLeft > 0) then 
    love.graphics.print(
      string.format("%.1f", reloadTimeLeft),
      self.x + self.width*0.25,
      self.y + self.height
    )
  end
end

function Hero:drawDebugWindow()
  DebugWindow:draw(self)
end

return Hero
