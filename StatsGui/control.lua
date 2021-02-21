local event = require("__flib__.event")
local migration = require("__flib__.migration")

local migrations = require("scripts.migrations")
local player_data = require("scripts.player-data")

local stats_gui = require("scripts.stats-gui")

-- -----------------------------------------------------------------------------
-- EVENT HANDLERS

-- BOOTSTRAP

event.on_init(function()
  global.players = {}
  global.research_progress_samples = {}
  for i, player in pairs(game.players) do
    player_data.init(i)
    player_data.refresh(player, global.players[i])
  end
end)

event.on_configuration_changed(function(e)
  if migration.on_config_changed(e, migrations) then
    global.research_progress_samples = {}
    for i, player in pairs(game.players) do
      player_data.refresh(player, global.players[i])
    end
  end
end)

-- PLAYER

event.on_player_created(function(e)
  local player = game.get_player(e.player_index)
  player_data.init(e.player_index)
  player_data.refresh(player, global.players[e.player_index])
end)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)

event.register(
  {
    defines.events.on_player_display_resolution_changed,
    defines.events.on_player_display_scale_changed
  },
  function(e)
    local player = game.get_player(e.player_index)
    local player_table = global.players[e.player_index]
    stats_gui.set_width(player, player_table)
  end
)

-- SETTINGS

event.on_runtime_mod_setting_changed(function(e)
  if string.sub(e.setting, 1, 8) == "statsgui" then
    local player = game.get_player(e.player_index)
    local player_table = global.players[e.player_index]
    if e.setting == "statsgui-single-line" then
      -- recreate the GUI to change the frame direction
      player_data.refresh(player, player_table)
    else
      player_data.update_settings(player, player_table)
    end
  end
end)

-- TICK

-- update stats once per second
event.on_nth_tick(60, function()
  for _, player in pairs(game.connected_players) do
    local player_table = global.players[player.index]
    stats_gui.update(player, player_table)
  end
end)
