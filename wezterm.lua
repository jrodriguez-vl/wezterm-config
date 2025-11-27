-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- config.disable_default_key_bindings = true

local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config(config)

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

config.font = wezterm.font("JetBrains Mono", { weight = 'Bold' })
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

--workspace switcher
config.default_workspace = "~"

local function get_default_schema()
    local default_schema = {
        sessionizer.DefaultWorkspace { label_overwrite= "~" },
        -- sessionizer.AllActiveWorkspaces {},
        processing = {
            sessionizer.for_each_entry(function(entry)
                entry.label = entry.label:gsub(wezterm.home_dir, "~")
            end)
        }
    }
    return default_schema
end


local function list_directories_in_path(path)
  local cmd
  if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    -- Windows command to list directories only
    cmd = { 'cmd.exe', '/c', 'dir', path, '/AD', '/B' }
  else
    -- Linux/macOS command to list directories only
    cmd = { 'ls', '-d', path .. '*/' }
  end

  local success, stdout, stderr = wezterm.run_child_process(cmd)

  if success then
    -- Split the output into lines and filter out empty strings
    local directories = {}
    for entry in stdout:gmatch("([^\r\n]+)") do
      if entry ~= '' then
        table.insert(directories, path .. entry)
      end
    end
    return directories
  else
    wezterm.log_error('Error listing directories:', stderr)
    return nil
  end
end

local function build_schema(paths)
    local results = get_default_schema()

    for _, path in ipairs(paths) do
        local search_path = wezterm.home_dir .. path
        local to_add = list_directories_in_path(search_path)
        for _, row in ipairs(to_add) do
            local entry = { label = row, id = row }
            table.insert(results, entry)
        end
    end

    return results
end

local work_schema = build_schema({ "\\work\\vlg\\" })
local game_schema = build_schema({ "\\gamedev\\" })

-- keymaps
config.leader = {
    key = 'a',
    mods = 'CTRL',
    timeout_milliseconds = 2000,
}

config.keys = {
    --remove blocking default shortcuts
    { key = "6", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment, },

    -- { key = "p", mods = "SHIFT|CTRL", action = wezterm.action.ActivateCommandPalette, },

    -- send increment to neovim bb
    { key = "a", mods = "LEADER|CTRL", action = act.SendKey { key = "a", mods = "CTRL" } },

    -- Split panes
    { key = "v", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }), }, -- Split vertically (right)
    { key = "h", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }), },-- Split horizontally (bottom)

    -- New tab
    { key = 'c', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
    -- Next tab
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    -- Previous tab
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },


    { key = '9', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },
    { key = '0', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },

    -- Close tab
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentTab({ confirm = false }) },

    { key = 'l', mods = 'LEADER', action = workspace_switcher.switch_to_prev_workspace() },
    { key = 's', mods = 'LEADER', action = workspace_switcher.switch_workspace() },

    { key = 'f', mods = 'LEADER', action = sessionizer.show(work_schema) },
    { key = 'g', mods = 'LEADER', action = sessionizer.show(game_schema) },
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
