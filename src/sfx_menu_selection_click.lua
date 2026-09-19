local sfx_menu_selection_click = {
  love.audio.newSource('share/nenadsimic_menu_selection_click.ogg', 'static')
}

function sfx_menu_selection_click:play()
  love.audio.stop(self[1])
  love.audio.play(self[1])
end

return sfx_menu_selection_click
