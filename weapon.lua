local class = require "middleclass"
local Magazine = require "magazine"
local cron = require "cron"

Weapon = class("Weapon")

function Weapon:initialize(reloadTime, fireRate, weight, projectileSpeed, damage, magazine)
  self.fireRate = fireRate or 0.2
  self.weight = weight or 100
  self.projectileSpeed = projectileSpeed or 300
  self.damage = damage or 1
  self.magazine = magazine or Magazine:new()
  self.reloadTime = reloadTime or 2
  self.reloadTimeLeft = 0
  self.isReloading = false
end

function Weapon:update(deltaTime)
  if not(reloadCron == nil) then
    
    self.isReloading = not (reloadCron:update(deltaTime))
    
    if (self.isReloading) then
      self.reloadTimeLeft = self.reloadTimeLeft - deltaTime
    elseif not (self.isReloading) then
      self.reloadTimeLeft = 0
    end
    
  end
  -- maybe delete the cron ?
end

function Weapon:fire(startX, startY, targetX, targetY)
  
  if self.isReloading then
    return nil
  end
  
  local projectile = self.magazine:spendProjectile()
  
  -- fire towards target possition
  if not(projectile == nil) then
    projectile.speed = self.projectileSpeed
    projectile.damage = self.damage
    projectile.x = startX
    projectile.y = startY
    
    -- get angle towards target from current possition
    local angle = math.atan2((targetY - startY), (targetX - startX))
 
		local dx = projectile.speed * math.cos(angle)
		local dy = projectile.speed * math.sin(angle)
    
    projectile.dx = dx
    projectile.dy = dy
  end

  return projectile
end

function Weapon:reload()
  reloadCron = cron.after(self.reloadTime, self.magazine.reload, self.magazine, 10)
  self.reloadTimeLeft = self.reloadTime
end

return Weapon