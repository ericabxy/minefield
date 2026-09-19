local gfx_minesweeper = require('src.gfx_minesweeper')
local cell = require('src.cell')

local grid = {
  x_count = 19,
  y_count = 14,
  xsize = 16,
  ysize = 16,
  cells = {}
}

for y = 1, grid.y_count do
  grid.cells[y] = {}
  for x = 1, grid.x_count do
    grid.cells[y][x] = cell:new() 
  end
end

function grid:init(xx, yy)
  local possible_flower_positions = {}
  self.cells = {}
  for y = 1, self.y_count do
    self.cells[y] = {}
    for x = 1, self.x_count do
      if not (x == xx and y == yy) then
        self.cells[y][x] = cell:new()
        table.insert(possible_flower_positions, {x = x, y = y})
      end
    end
  end
  for flower_index = 1, 40 do
    local position = table.remove(
      possible_flower_positions,
      love.math.random(#possible_flower_positions)
    )
    self.cells[position.y][position.x].flower = true
  end
  return self
end

function grid:seedbombs()
end

function grid:draw(name, x, y)
  love.graphics.draw(
    gfx_minesweeper.texture,
    gfx_minesweeper[name],
    8 + (x - 1) * self.xsize,
    8 + (y - 1) * self.ysize
  )
end

function grid:surrounding_flower_count(x, y)
  local count = 0
  for dy = -1, 1 do
    for dx = -1, 1 do
      if not (dy == 0 and dx == 0)
      and self.cells[y + dy]
      and self.cells[y + dy][x + dx]
      and self.cells[y + dy][x + dx].flower then
        count = count + 1
      end
    end
  end
  return count
end

function grid:is_bombed(x, y)
  if self.cells[y] and self.cells[y][x] then
    return self.cells[y][x].flower
  end
end

function grid:is_covered(x, y)
  if self.cells[y] and self.cells[y][x] then
    return self.cells[y][x].state == 'covered'
  end
end

function grid:is_flagged(x, y)
  if self.cells[y] and self.cells[y][x] then
    return self.cells[y][x].state == 'flagged'
  end
end

function grid:is_marked(x, y)
  if self.cells[y] and self.cells[y][x] then
    return self.cells[y][x].state == 'question'
  end
end

function grid:flag(x, y)
  if self.cells[y] and self.cells[y][x] then
    self.cells[y][x].state = 'flagged'
  end
end

function grid:mark(x, y)
  if self.cells[y] and self.cells[y][x] then
    self.cells[y][x].state = 'question'
  end
end

function grid:cover(x, y)
  if self.cells[y] and self.cells[y][x] then
    self.cells[y][x].state = 'covered'
  end
end

function grid:uncover(x, y)
  if self.cells[y] and self.cells[y][x] then
    self.cells[y][x].state = 'uncovered'
  end
end

function grid:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return grid
