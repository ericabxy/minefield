--- A minesweeper game for Lutro.
--- Copyright (C) 2026  Eric Abides

--- This program is free software: you can redistribute it and/or modify
--- it under the terms of the GNU General Public License as published by
--- the Free Software Foundation, either version 3 of the License, or
--- (at your option) any later version.

--- This program is distributed in the hope that it will be useful,
--- but WITHOUT ANY WARRANTY; without even the implied warranty of
--- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--- GNU General Public License for more details.

--- You should have received a copy of the GNU General Public License
--- along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
