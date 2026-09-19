local gfx_minesweeper = require('src.gfx_minesweeper')

local cell = {
  texture = gfx_minesweeper.texture,
  quad = gfx_minesweeper.covered,
  xsize = 16,
  ysize = 16,
  flower = false,
  state = 'covered'
}

function cell:draw(name, x, y)
  love.graphics.draw(
    self.texture,
    gfx_minesweeper[name],
    8 + (x - 1) * self.xsize,
    8 + (y - 1) * self.ysize
  )
end

function cell:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return cell
