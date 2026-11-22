local awful   = require("awful")
local menubar = require("menubar")

local M = {
    name = "menubar",
    description = "A launcher menu for applications"
}

function M.setup(core)
    local settings = core.settings
    -- menubar.utils.terminal = settings.apps.term or "xterm"
    local modkey = core.settings.modkey

    awful.keyboard.append_global_keybindings {
        group = "launcher",
        awful.key({ modkey }, "p", function()
            menubar.show()
        end)
    }
end

return M