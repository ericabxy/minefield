local gfx_minesweeper = require('src.gfx_minesweeper')

local pointer = {}

function pointer.draw()
  love.graphics.draw(
    gfx_minesweeper.texture,
    gfx_minesweeper.pointer,
    love.mouse.getX(),
    love.mouse.getY()
  )
end

return pointer
