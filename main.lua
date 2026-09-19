local gfx_minesweeper = require('src.gfx_minesweeper')
local grid = require('src.grid')

local grid0 = grid:new():init()
local image = love.graphics.newImage('share/frostc_minesweeper.png')
local covered = love.graphics.newQuad(16, 32, 16, 16, 64, 48)
local one_was_pressed = false
local two_was_pressed = false

function love.load()
  cell_size = 16
  grid_x_count = 19
  grid_y_count = 14
  first_click = true
end

function love.update(dt)
  selected_x = math.floor(love.mouse.getX() / cell_size - .5) + 1
  selected_y = math.floor(love.mouse.getY() / cell_size - .5) + 1
  if selected_x > grid_x_count or selected_x < 1 or
     selected_y > grid_y_count or selected_y < 1 then
    return
  end
  if not love.mouse.isDown(1) and one_was_pressed == true then
    uncover()
    one_was_pressed = false
  elseif love.mouse.isDown(1) then
    one_was_pressed = true
  end
  if not love.mouse.isDown(2) and two_was_pressed == true then
    setflag(2)
    two_was_pressed = false
  elseif love.mouse.isDown(2) then
    two_was_pressed = true
  end
end

function love.draw()
  for y = 1, grid_y_count do
    for x = 1, grid_x_count do
      local surrounding_flower_count = grid0:surrounding_flower_count(x, y)
      local quad
      if not grid0:is_covered(x, y) then
        grid0:draw('uncovered', x, y)
      else
        if x == selected_x and y == selected_y then
          if love.mouse.isDown(1) then
            if grid0:is_flagged(x, y) then
              grid0:draw('covered', x, y)
            else
              grid0:draw('uncovered', x, y)
            end
          else
            grid0:draw('covered_highlighted', x, y)
          end
        else
            grid0:draw('covered', x, y)
        end
      end
      if grid0:is_bombed(x, y) and gameover then
        grid0:draw('flower', x, y)
      elseif surrounding_flower_count > 0
        and not grid0:is_covered(x, y) then
          grid0:draw(surrounding_flower_count, x, y)
      end
      if grid0:is_flagged(x, y) then
        grid0:draw('flagged', x, y)
      end
    end
  end
  love.graphics.draw(
    image, gfx_minesweeper.pointer,
    love.mouse.getX(),
    love.mouse.getY()
  )
end

function uncover()
  if not gameover then
    if not grid0:is_flagged(selected_x, selected_y) then
      if first_click then
        first_click = false
        grid0:init(selected_x, selected_y)
        grid0:seedbombs()
      end
      if grid0:is_bombed(selected_x, selected_y) then
        grid0:uncover(selected_x, selected_y)
        gameover = true
      else
        local stack = {{ x = selected_x, y = selected_y }}
        while #stack > 0 do
          local current = table.remove(stack)
          local x = current.x
          local y = current.y
          grid0:uncover(x, y)
          if grid0:surrounding_flower_count(x, y) == 0 then
            for dy = -1, 1 do
              for dx = -1, 1 do
                if not (dx == 0 and dy == 0)
                and grid0.cells[y + dy]
                and grid0.cells[y + dy][x + dx]
                and (
                  grid0:is_covered(x + dx, y + dy) or
                  grid0:is_marked(x + dx, y + dy)
                ) then
                  table.insert(stack, {
                    x = x + dx,
                    y = y + dy,
                  })
                end
              end
            end
          end
        end
      end
    end
  end
end

function setflag()
  if not gameover then
    if grid0:is_covered(selected_x, selected_y) then
      grid0:flag(selected_x, selected_y)
    elseif grid0:is_flagged(selected_x, selected_y) then
      --grid0:mark(selected_x, selected_y)
    --elseif grid0:is_marked(selected_x, selected_y) then
      grid0:cover(selected_x, selected_y)
    end
  end
end
