--- See https://wezterm.org/config/lua/config/index.html
--- to read and understand configuration file

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

--- General
config.automatically_reload_config = true
config.check_for_updates = false
config.check_for_updates_interval_seconds = 86400
config.show_update_window = false
config.use_ime = true
config.ime_preedit_rendering = 'Builtin'

--- Env
config.term = "xterm-256color"

--- Animation
config.prefer_egl = true
config.front_end = 'WebGpu'
config.max_fps = 60
config.animation_fps = 10
config.webgpu_power_preference = "LowPower"

--- Colors
config.color_scheme = 'Snazzy (base16)'
config.bold_brightens_ansi_colors = false

--- Window
config.use_fancy_tab_bar = true
config.native_macos_fullscreen_mode = true
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

--- Scrolling
config.scrollback_lines = 10000

--- Font
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14
config.freetype_load_target = "Light"

--- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

return config
