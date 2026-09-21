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
local sfx_menu_selection_click = love.audio.newSource('share/nenadsimic_menu_selection_click.ogg', 'static')
sfx_menu_selection_click:setVolume(.20)
local sfx_click = love.audio.newSource('share/qubodup_click.ogg', 'static')
local sfx_click_click = love.audio.newSource('share/qubodup_click_stereo.ogg', 'static')
local sfx_click_negative = love.audio.newSource('share/qubodup_negative_stereo.ogg', 'static')
local sfx_click_negative2 = love.audio.newSource('share/qubodup_negative2_stereo.ogg', 'static')
local sfx_click_positive = love.audio.newSource('share/qubodup_positive_stereo.ogg', 'static')
local sfx_vgdeathsound = love.audio.newSource('share/fupi_vgdeathsound.ogg', 'static')
local sfx_vgmenuhighlight = love.audio.newSource('share/fupi_vgmenuhighlight.ogg', 'static')
local sfx_vgmenuselect = love.audio.newSource('share/fupi_vgmenuselect.ogg', 'static')
local font = require('src.gfx_dos_8x8_font')
local pointer = require('src.pointer')
local grid = require('src.grid')

local one_was_pressed = false
local two_was_pressed = false

function love.load()
  grid0 = grid:new():init()
  cell_size = 16
  grid_x_count = 19
  grid_y_count = 14
  first_click = true
  gameover = false
  nbombs = 40
  nflags = 0
end

function love.update(dt)
  local previous_x, previous_y = selected_x, selected_y
  selected_x = math.floor(love.mouse.getX() / cell_size - .5) + 1
  selected_y = math.floor(love.mouse.getY() / cell_size - .5) + 1
  if selected_x ~= previous_x or selected_y ~= previous_y then
    if not gameover then
      love.audio.stop(sfx_click_click)
      love.audio.play(sfx_click_click)
    end
  end
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
  pointer:draw()
  love.graphics.setFont(font)
  love.graphics.print('BOMBS: ' .. nbombs - nflags, 8, 0)
end

function uncover()
  if not gameover then
    if not grid0:is_flagged(selected_x, selected_y) then
      if first_click then
        grid0:init(selected_x, selected_y)
        first_click = false
      end
      if grid0:is_bombed(selected_x, selected_y) then
        if not sfx_vgdeathsound:isPlaying() then
          love.audio.play(sfx_vgdeathsound)
        end
        grid0:uncover(selected_x, selected_y)
        gameover = true
      else
        local stack = {{ x = selected_x, y = selected_y }}
        while #stack > 0 do
          love.audio.stop(sfx_click_click)
          love.audio.play(sfx_click_click)
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
  else
    love.audio.stop(sfx_vgdeathsound)
    love.load()
  end
end

function setflag()
  if not gameover then
    if grid0:is_covered(selected_x, selected_y) then
      grid0:flag(selected_x, selected_y)
      nflags = nflags + 1
      love.audio.stop(sfx_vgmenuselect)
      love.audio.play(sfx_vgmenuselect)
    elseif grid0:is_flagged(selected_x, selected_y) then
      --grid0:mark(selected_x, selected_y)
    --elseif grid0:is_marked(selected_x, selected_y) then
      grid0:cover(selected_x, selected_y)
      nflags = nflags - 1
      love.audio.stop(sfx_vgmenuhighlight)
      love.audio.play(sfx_vgmenuhighlight)
    end
  end
end
