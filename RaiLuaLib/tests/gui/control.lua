local event = require('lualib.event')
local gui = require('lualib.gui')
local mod_gui = require('mod-gui')

gui.load_templates{
  pushers = {
    horizontal = {type='empty-widget', name='pusher', style={horizontally_stretchable=true}},
    vertical = {type='empty-widget', name='pusher', style={vertically_stretchable=true}}
  },
  toolbar = {
    frame = {type='frame', name='toolbar', style={name='subheader_frame', vertical_align='center'}},
    label = {type='label', name='label', style='subheader_caption_label'}
  },
  buttons = {
    close = {type='sprite-button', name='close_button', style='close_button', sprite='utility/close_white', hovered_sprite='utility/close_black',
      clicked_sprite='utility/close_black', mouse_button_filter={'left'}},
    tool_grey = {type='sprite-button', style='tool_button'}
  },
  checkbox = {type='checkbox', name='checkkbox', caption='Checkbox'}
}
gui.load_handlers{
  auto_clear_checkbox = {
    on_checked_state_changed = function(e) game.print(serpent.block(e)) end
  },
  cardinals_checkbox = {
    on_checked_state_changed = function(e) game.print(serpent.block(e)) end
  },
  grid_type_switch = {
    on_switch_state_changed = function(e) game.print(serpent.block(e)) end
  },
  divisor_slider = {
    on_value_changed = function(e) game.print(serpent.block(e)) end
  },
  divisor_textfield = {
    on_confirmed = function(e) game.print(serpent.block(e)) end,
    on_text_changed = function(e) game.print(serpent.block(e)) end
  }
}

event.on_player_created(function(e)
  mod_gui.get_button_flow(game.get_player(e.player_index)).add{type='button', name='gui_module_mod_gui_button', style=mod_gui.button_style, caption='Template'}
end)

event.on_gui_click(function(e)
  local player = game.get_player(e.player_index)
  local frame_flow = mod_gui.get_frame_flow(player)
  local window = frame_flow.demo_window
  if window then
    gui.destroy(window, e.player_index)
  else
    local data = gui.create(frame_flow,
      {type='frame', name='demo_window', style='dialog_frame', direction='vertical', children={
        {type='flow', name='checkboxes_flow', direction='horizontal', children={
          {template='checkbox', name='autoclear', caption='Auto-clear', state=true, handlers='auto_clear_checkbox', save_as=true},
          {template='pushers.horizontal'},
          {template='checkbox', name='cardinals', caption='Cardinals only', state=true, handlers='cardinals_checkbox', save_as=true}
        }},
        {type='flow', name='switch_flow', style={vertical_align='center'}, direction='horizontal', children={
          {type='label', name='label', caption='Grid type:'},
          {template='pushers.horizontal'},
          {type='switch', name='switch', left_label_caption='Increment', right_label_caption='Split', state='left', handlers='grid_type_switch', save_as=true}
        }},
        {type='flow', name='divisor_label_flow', style={horizontal_align='center', horizontally_stretchable=true}, children={
          {type='label', name='label', style='caption_label', caption='Number of tiles per subgrid', save_as='grid_type_label'},
        }},
        {type='flow', name='divisor_flow', style={horizontal_spacing=8, vertical_align='center'}, direction='horizontal', children={
          {type='slider', name='slider', style={name='notched_slider', horizontally_stretchable=true}, minimum_value=4, maximum_value=12, value_step=1, value=5,
            discrete_slider=true, discrete_values=true, handlers='divisor_slider', save_as=true},
          {type='textfield', name='textfield', style={width=50, horizontal_align='center'}, numeric=true, lose_focus_on_confirm=true, text=5,
            handlers='divisor_textfield', save_as=true}
        }}
      }},
      {player_index=e.player_index}
    )
  end
end, {gui_filters='gui_module_mod_gui_button'})