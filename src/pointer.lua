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

local pointer = {
  texture = gfx_minesweeper.texture,
  quad = gfx_minesweeper.pointer,
}

function pointer:do_uncover(grid)
end

function pointer:draw()
  love.graphics.draw(
    self.texture, self.quad,
    love.mouse.getX(),
    love.mouse.getY()
  )
end

function pointer:selected(grid)
  local x = math.floor(love.mouse.getX() / grid.xsize - .5) + 1
  local y = math.floor(love.mouse.getY() / grid.ysize - .5) + 1
  if x > grid.x_count or x < 1 or y > grid.y_count or y < 1 then
    return false  -- Pointer not within grid.
  end
  return {x = x, y = y}
end

function pointer:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return pointer
