local class = require "middleclass"
local Projectile = require "projectile"

Magazine = class("Magazine")

function Magazine:initialize(capacity, remaining, projectile)
  self.capacity = capacity or 10
  self.remaining = remaining or 10
  self.projectile = projectile or Projectile
end

function Magazine:spendProjectile()
  if(self.remaining > 0) then
    self.remaining = self.remaining - 1;
    return self.projectile:new()
  end
    return nil
end

function Magazine:numProjectilesNeededForReload()
  return self.capacity - self.remaining
end

function Magazine:reload(numProjectiles)
  if(self.remaining + numProjectiles > self.capacity) then
    self.remaining = self.capacity
  else
    self.remaining = self.remaining + numProjectiles
  end
end

return Magazine