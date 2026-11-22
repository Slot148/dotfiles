local awful = require("awful")
local wibox = require("wibox")

local function layoutbox(config)
    config = config or {}
    local layoutbox = awful.widget.layoutbox {

        screen = config.screen,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1)  end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1)  end),
        }
    }

    return layoutbox
end

return layoutbox