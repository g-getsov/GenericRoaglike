local class = require "middleclass"
local directions = require "directions"
local Weapon = require "weapon"
local DebugWindow = require "debugwindow"
local mousebuttons = require "mousebuttons"
local Map = require "map"

Hero = class("Hero")

function Hero:initialize(x, y, xCoord, yCoord, width, height, speed, direction)
  self.x = x or 0
  self.y = y or 0
  self.xCoord = xCoord or 0
  self.yCoord = yCoord or 0
  self.width = width or 50
  self.height = height or 50
  self.speed = speed or 250
  self.direction = direction or directions.down
  self.weapon = Weapon:new();
  self.shots = {}
  self.debugMode = false
  self.solid = true;
end

function Hero:shoot(targetX, targetY)

  local weapon = self.weapon

  local projectile = weapon:fire(
    self.xCoord + self.width/2,
    self.yCoord,
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

  local newX = self.xCoord
  local newY = self.yCoord

  if love.keyboard.isDown("left")
  or love.keyboard.isDown("a")
  then
    newX = self.xCoord - self.speed*deltaTime
    self.direction = directions.left
  end

  if love.keyboard.isDown("right")
  or love.keyboard.isDown("d")
  then
    newX = self.xCoord + self.speed*deltaTime
    self.direction = directions.right
  end

  if love.keyboard.isDown("up")
  or love.keyboard.isDown("w")
  then
    newY = self.yCoord - self.speed*deltaTime
    self.direction = directions.up
  end

  if love.keyboard.isDown("down")
  or love.keyboard.isDown("s")
  then
    newY = self.yCoord + self.speed*deltaTime
    self.direction = directions.down
  end

  -- only check for collision if not in noClip mode
  if(self.solid == true) then
    local xColision, yColision = Map:checkCollisionWithWorld(newX, newY, self.width, self.height)

    if(xColision == true) then newX = self.xCoord end
    if(yColision == true) then newY = self.yCoord end
  end

  self.xCoord = newX
  self.yCoord = newY
  Map:updateMapOffset(self.xCoord - self.x, self.yCoord - self.y)

  function love.keyreleased(key)
    if key == "r" then
      self.weapon:reload()
    elseif key == "p" then
      self.solid = not self.solid
    elseif key == "1" then
      self.debugMode = not self.debugMode
    end
  end

  function love.mousepressed(x, y, button)

    x = x + Map.worldOffsetX
    y = y + Map.worldOffsetY

    if button == mousebuttons.left then
      self:shoot(x, y)
    end
  end

end

function Hero:draw()

  love.graphics.setColor(50,250,50,255)
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
