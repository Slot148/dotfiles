local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local function textclock(config)

    local round = config.bar_settings.round or 0

    local format = "%H:%M"
    if config.orientation == "vertical" then
        format = "%H\n%M"
    end

    local clock_widget = wibox.widget {
        {
            {
                widget = wibox.widget.textclock,
                format = format,
                valign = "center",
                halign = "center",
                font   = beautiful.font
            },
            widget = wibox.container.margin,
            margins = {
                left   = (config.bar_settings.margin or 0)//2,
                right  = (config.bar_settings.margin or 0)//2,
                top    = (config.bar_settings.margin or 0)//4,
                bottom = (config.bar_settings.margin or 0)//4,
            },
        },
        widget = wibox.container.background,
        bg     = beautiful.bg_normal,
        fg     = beautiful.fg_normal,
        shape  = function (cr, w, h)
            gears.shape.rounded_rect(cr, w, h, round//2)
        end
    }

    awful.tooltip {
        objects = { clock_widget },
        timer_function = function ()
            return os.date("%a, %d %B %Y")
        end
    }

    -- local calendar = awful.widget.calendar_popup.month()

    -- clock_widget:buttons{
    --     awful.button({}, 1, function()
    --         calendar:toggle()
    --     end)
    -- }

    clock_widget:connect_signal("mouse::enter", function ()
        clock_widget.bg = beautiful.bg_focus
        clock_widget.fg = beautiful.fg_focus
    end)

    clock_widget:connect_signal("mouse::leave", function ()
        clock_widget.bg = beautiful.bg_normal
        clock_widget.fg = beautiful.fg_normal
    end)

    return { clock_widget, widget = wibox.container.rotate, direction = "north" }
end

return textclock