local M = {
    name = "screenshot",
    description = "simple screenshot tool",
    version = "1.0"
}

local utils = require("utils")
local awful = require("awful")

function M.setup(core)
    local settings = core.settings.screenshot
    local def_dir  = core.settings.dirs.pictures

    awful.keyboard.append_global_keybindings ({
        group = "screenshots",
        awful.key({         }, "Print", function() utils.screenshots.save { auto_save_delay = 0, interactive = false, directory = (settings.directory or def_dir) } end),
        awful.key({ "Shift" }, "Print", function() utils.screenshots.save { auto_save_delay = 0, interactive = true, directory = (settings.directory or def_dir) } end)
    })
end