local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local function tasklist(config)
    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c) 
            if client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise=true})
            end
        end),
        awful.button({}, 3, function(c)
            c:emit_signal("request::activate", "tasklist", {raise=true})
            awful.menu.client_list({client = c, theme = { width = 250 }})
        end),
        awful.button({}, 4, function() awful.client.focus.byidx(1) end),
        awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
    )

    local tasklist = awful.widget.tasklist {
        screen = config.screen,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout   = {
            spacing_widget = {
                {
                    forced_width  = (config.bar_settings.height or 20) * 2,
                    forced_height = (config.bar_settings.height or 20) * 2,
                    thickness     = 1,
                    color         = "#777777",
                    widget        = wibox.widget.separator
                },
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            },
            spacing = (config.bar_settings.height or 20) // 4,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 2,
                id            = "background_role",
                widget        = wibox.container.background,
            },
            {
                awful.widget.clienticon,
                margins = 2,
                widget  = wibox.container.margin
            },
            nil,
            layout = wibox.layout.align.vertical,
        },
    }

    return { tasklist, widget = wibox.container.rotate, direction = config.direction }
end

return tasklist