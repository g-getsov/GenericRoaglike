DebugWindow = {}

function DebugWindow:draw(obj)
  love.graphics.print(obj.x, 0, 0)
  love.graphics.print(obj.y, 0, 15)
-- for idx, value in ipairs(obj) do
--   txt = idx .. " : " .. value
--  love.graphics.print(txt, x, y)
--   y = y + 20
-- end
end

return DebugWindow