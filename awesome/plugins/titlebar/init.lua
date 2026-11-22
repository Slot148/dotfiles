local awful = require("awful")
local wibox = require("wibox")
local ruled = require("ruled")

local M = {
    name = "titlebar",
    description = ""
}

function M.setup(core)
    local config = core.settings or {}
    local settings = config.titlebars or {}
    local client = _G.client

    client.connect_signal("request::titlebars", function(c)
        local buttons = {
            awful.button({ }, 1, function()
                c:activate { context = "titlebar", action = "mouse_move"  }
            end),
            awful.button({ }, 3, function()
                c:activate { context = "titlebar", action = "mouse_resize"}
            end),
        }

        awful.titlebar(c).widget = {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    halign = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end)

    if settings then
        ruled.client.append_rule {
            id = "titlebars",
            rule_any = { type = { "normal", "dialog" }},
            properties = { titlebars_enabled = settings.enable ~= false }
        }
    end
end

return M