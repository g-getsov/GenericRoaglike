local class = require "middleclass"
local Tile = require "tile"
local directions = require "directions"

Map = class("Map")

Map.worldOffsetX = 0
Map.worldOffsetY = 0

Map.currentMap = nil

function Map:initialize(width, height, tileSize)
  -- in units
  self.width = width
  self.height = height

  -- pixel
  self.tileSize = tileSize
  self.tiles = self:constructBlankTileGrid(width, height, tileSize)
  self:setCurrentMap()
end

function Map:setCurrentMap()
  Map.currentMap = self
end

function Map:updateMapOffset(xOffset, yOffset)
  Map.worldOffsetX = xOffset
  Map.worldOffsetY = yOffset
end

function Map:constructBlankTileGrid(width, height, tileSize)

  local tiles = {}
  for x = 0, width do
    tiles[x] = {}
    for y = 0, height do
      tiles[x][y] = Tile:new(x, y, tileSize)
    end
  end

  return tiles
end

function Map:generate(
  minNumRooms,
  maxNumRooms,
  minRoomWidth,
  maxRoomWidth,
  minRoomHeight,
  maxRoomHeight,
  minCoridorLength,
  maxCoridorLength,
  maxCoridorWidth
)

  local start = os.clock()
  print("Begining map generation...")

  local numRooms = math.random(minNumRooms, maxNumRooms)

  repeat
    xPos = self.width/2 + math.random(-5,5)
  until(xPos > 0 and xPos < self.width)

  repeat
    yPos = self.height/2 + math.random(-5,5)
  until(yPos > 0 and yPos < self.height)

  for i = 0, numRooms do

    repeat

      print("Generating room ".. i .."...")

      local isInBoundary = false

      roomWidth = math.random(minRoomWidth, maxRoomWidth)
      roomHeight = math.random(minRoomHeight, maxRoomHeight)

      --first room
      if ((xPos + roomWidth) < self.width)
      and ((yPos + roomHeight) < self.height) then
        isInBoundary = true
      end

    until(isInBoundary)

    roomEndX = xPos + roomWidth
    roomEndY = yPos + roomHeight

    for x = xPos, roomEndX do
      for y = yPos, roomEndY do
        tile = self.tiles[x][y]
        tile.solid = false
      end
    end

    xPos, yPos = self:generateCoridor(
      xPos,
      yPos,
      roomWidth,
      roomHeight,
      minCoridorLength,
      maxCoridorLength,
      maxCoridorWidth
    )

  end

  print("Map generation took " .. os.clock() - start)

end

function Map:generateCoridor(
  x,
  y,
  roomWidth,
  roomHeight,
  minCoridorLength,
  maxCoridorLength,
  maxCoridorWidth
)
  local coridorDx = math.random(minCoridorLength, maxCoridorLength);
  local coridorDy = math.random(1, maxCoridorWidth);

  local coridorStartX = nil
  local coridorStartY = nil

  local isInBoundary = true

  repeat

    print("Generating coridor ...")

    direction = math.random(1,4);

    if direction == directions.left then
      coridorDx = -coridorDx
      coridorStartX = x
      coridorStartY = math.random(y, y + roomHeight);

    elseif direction == directions.right then
      coridorStartX = x + roomWidth
      coridorStartY = math.random(y, y + roomHeight);

    elseif direction == directions.up then
      coridorDy = -coridorDy
      coridorStartY = y
      coridorStartX = math.random(x, x + roomWidth);

    elseif direction == directions.down then
      coridorStartY = y + roomHeight
      coridorStartX = math.random(x, x + roomWidth);
    end

  until(isInBoundary)

  -- swap differences to account for direction
  if direction == directions.up
  or direction == directions.down
  then
    coridorDx, coridorDy = coridorDy, coridorDx
  end

  coridorEndX = coridorStartX + coridorDx
  coridorEndY = coridorStartY + coridorDy

  for x = coridorStartX, coridorEndX do
    for y = coridorStartY, coridorEndY do
      tile = self.tiles[x][y]
      tile.solid = false
    end
  end

  return coridorEndX, coridorEndY
end

function Map:draw()
  for i,row in ipairs(self.tiles) do
    for j,tile in ipairs(row) do
      tile:draw(
        Map.worldOffsetX,
        Map.worldOffsetY
      )
    end
  end
end

function Map:checkCollisionWithWorld(ax1,ay1,aw,ah)

  local map = Map.currentMap

  for i,row in ipairs(map.tiles) do
    for j,tile in ipairs(row) do
      bx1 = tile:getX()
      by1 = tile:getY()
      bw = tile:getWidth()
      bh = tile:getHeight()

      local hasColided = false
      local xColision = false
      local yColision = false

      if(tile.solid) then
        local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
        xColision = ax1 < bx2 and ax2 > bx1
        yColision = ay1 < by2 and ay2 > by1
        hasColided = xColision and yColision
      end

      if hasColided == true then
        print("Collision with block ".. tile:getXUnitPosition() ..",".. tile:getYUnitPosition())
        return xColision, yColision
      end

    end
  end
end

function Map:getWidth() return self.x * self.tileSize end
function Map:getHeight() return self.y * self.tileSize end
function Map:getUnitWidth() return self.x end
function Map:getUnitHeight() return self.y end

return Map
