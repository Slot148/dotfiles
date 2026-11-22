local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function separator(config)
    local separator  = {
        widget       = wibox.widget.separator,
        orientation  = "vertical",
        color        = beautiful.bg_focus,
        forced_width = 4
    }

    return { separator, widget = wibox.container.rotate, direction = config.direction }
end

return separator