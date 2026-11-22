local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function taglist(config)

    local direction1 = "north"
    local direction2 = "north"

    if config.direction == "east" or config.direction == "west" then
        direction1 = "east"
        direction2 = "west"
    end

    local taglist = awful.widget.taglist {
        screen = config.screen or nil,
        filter = awful.widget.taglist.filter.all,
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                        halign = "center",
                        valign = "center",
                    },
                    widget = wibox.container.rotate,
                    direction = direction1
                },
                widget = wibox.container.margin,
                left = 5,
                right = 5
            },
            id = "background_role",
            widget = wibox.container.background
        }
    }

    return { taglist, widget = wibox.container.rotate, direction = direction2 }
end

return taglist