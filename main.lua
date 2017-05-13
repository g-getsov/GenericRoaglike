local directions = require "directions"
local Hero = require "hero"

function love.load(arg)
  
  if arg and arg[#arg] == "-debug" then
    require("mobdebug").start() 
  end
  
  hero = Hero:new(50, 50, 50, 50, 100, directions.down)
  
end

function love.draw()
  hero:draw()
  
  for i,v in ipairs(hero.shots) do
    v:draw()
  end
end
  
function love.update(deltaTime)
  hero:update(deltaTime)
  updateEntityPosition(hero.shots, deltaTime)
end

function updateEntityPosition(entities, deltaTime)
  
  for i,entity in ipairs(entities) do
    entity.x = entity.x + (entity.dx * deltaTime)
    entity.y = entity.y + (entity.dy * deltaTime)
  end
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end