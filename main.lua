local directions = require "directions"
local Hero = require "hero"
local Map = require "map"
local gamera = require "gamera"

function love.load(arg)

  if arg and arg[#arg] == "-debug" then
    require("mobdebug").start()
  end

  local WINDOW_WIDTH = 1280
  local WINDOW_HEIGHT = 800

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

  math.randomseed(os.time())

  local MAP_WIDTH_UNITS = 100
  local MAP_HEIGHT_UNITS = 100
  local MAP_TILE_SIZE = 64

  --hero setup
  local HERO_SCREEN_COORD_X = love.graphics.getWidth()/2
  local HERO_SCREEN_COORD_Y = love.graphics.getHeight()/2
  local HERO_MAP_COORD_X = (MAP_WIDTH_UNITS * MAP_TILE_SIZE) /2
  local HERO_MAP_COORD_Y = (MAP_HEIGHT_UNITS * MAP_TILE_SIZE) /2
  local HERO_PIXEL_WIDTH = 32
  local HERO_PIXEL_HEIGHT = 32
  local HERO_SPEED = 250

  --map setup
  local MIN_NUM_ROOMS = 3
  local MAX_NUM_ROOMS = 5
  local MIN_ROOM_WIDTH = 4
  local MAX_ROOM_WIDTH = 10
  local MIN_ROOM_HEIGHT = 4
  local MAX_ROOM_HEIGHT = 10
  local MIN_CORIDOR_LENGTH = 2
  local MAX_CORIDOR_LENGTH = 10
  local MAX_CORIDOR_WIDTH = 1

  map = Map:new(
    MAP_WIDTH_UNITS,
    MAP_HEIGHT_UNITS,
    MAP_TILE_SIZE
  )

  map:generate(
    MIN_NUM_ROOMS,
    MAX_NUM_ROOMS,
    MIN_ROOM_WIDTH,
    MAX_ROOM_WIDTH,
    MIN_ROOM_HEIGHT,
    MAX_ROOM_HEIGHT,
    MIN_CORIDOR_LENGTH,
    MAX_CORIDOR_LENGTH,
    MAX_CORIDOR_WIDTH
  )

  hero = Hero:new(
    HERO_SCREEN_COORD_X,
    HERO_SCREEN_COORD_Y,
    HERO_MAP_COORD_X,
    HERO_MAP_COORD_Y,
    HERO_PIXEL_WIDTH,
    HERO_PIXEL_HEIGHT,
    HERO_SPEED,
    directions.down
  )

  cam = gamera.new(0,0, WINDOW_WIDTH, WINDOW_HEIGHT)
  cam:setWindow(0,0, WINDOW_WIDTH, WINDOW_HEIGHT)
  cam:setScale(1.0)

end

function love.draw()
    cam:draw(function()
        map:draw()
        hero:draw()
        for i,v in ipairs(hero.shots) do
            v:draw()
        end
    end)
end

function love.update(deltaTime)
  hero:update(deltaTime)
  updateEntityPosition(hero.shots, deltaTime)
end

function updateEntityPosition(entities, deltaTime)

  for i,entity in ipairs(entities) do
    entity.x = entity.x + (entity.dx * deltaTime)
    entity.y = entity.y + (entity.dy * deltaTime)
    
    local xColision, yColision = Map:checkCollisionWithWorld(entity.x, entity.y, entity:getWidth(), entity:getHeight())

    if(xColision == true or yColision == true) then 
      table.remove(entities, i)
    end
  end
end
