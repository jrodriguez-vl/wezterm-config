-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

-- workspace_switcher.apply_to_config(config)

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.cell_width = 0.9
config.window_background_opacity = 0.9
config.prefer_egl = true
config.font_size = 12.0

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}


config.window_frame = {
	-- font = wezterm.font({ family = "Iosevka Custom", weight = "Regular" }),
	active_titlebar_bg = "#0c0b0f",
	-- active_titlebar_bg = "#181616",
}

--
config.window_decorations = "NONE | RESIZE"
config.default_prog = { "C:/Program Files/Git/bin/bash.exe" }
config.initial_cols = 80

-- tabs
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- keymaps
config.leader = {
    key = 'a',
    mods = 'CTRL',
    timeout_milliseconds = 10000,
}

--workspace switcher
-- config.default_workspace = "~"

local my_schema = {
  -- "Workspace 1",  -- Simple string entry, expands to { label = "Workspace 1", id = "Workspace 1" }
  sessionizer.DefaultWorkspace {},
  sessionizer.AllActiveWorkspaces {},
  -- sessionizer.FdSearch "~/my_projects", -- Searches for git repos in ~/my_projects
}

config.keys = {
  -- Split panes
    { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }), }, -- Split vertically (right)
    { key = "h", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }), },-- Split horizontally (bottom)

    -- New tab
    { key = 'c', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
    -- Next tab
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    -- Previous tab
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    -- Close tab
    -- { key = 'x', mods = 'LEADER', action = act.CloseCurrentTab({ confirm = true }) },
    --
  -- Switch between workspaces (Tmux sessions)
    -- Show launcher to switch workspaces 
    -- { key = "w", mods = "LEADER", action = act.ShowWorkspaces, },
    -- Switch to a specific workspace
    -- { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs({ fuzzy = true }) },
    -- Switch to next/previous workspace
    { key = 'f', mods = 'LEADER', action = sessionizer.show(my_schema) },
    { key = 'f', mods = 'LEADER', action = sessionizer.show(my_schema) },
    -- { key = '(', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },
    -- { key = "9", mods = "LEADER", action = act.PaneSelect },
}


-- For example, changing the color scheme:
config.color_scheme = "Cloud (terminal.sexy)"
config.colors = {
	background = "#0e0e12", -- bright washed lavendar
	cursor_border = "#bea3c7",
	cursor_bg = "#bea3c7",

	tab_bar = {
		background = "#0c0b0f",
		active_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#bea3c7",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#f8f2f5",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		new_tab = {
			bg_color = "#0c0b0f",
			fg_color = "white",
		},
	},
}

return config
