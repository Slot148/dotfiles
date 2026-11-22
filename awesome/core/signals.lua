local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")
local ruled   = require("ruled")
local gears   = require("gears")
local beautiful = require("beautiful")

local M = {}

function M.load()

    client.connect_signal("mouse::enter", function(c)
        c:activate { context = "mouse_enter", raise = false }
    end)

    ruled.notification.connect_signal("request::rules", function()
        ruled.notification.append_rule {
            rule = {},
            properties = {
                screen           = awful.screen.preferred,
                implicit_timeout = 5,
            }
        }
    end)

    client.connect_signal("request::manage", function (c)
        c.shape = function (cr, w, h)
            gears.shape.rounded_rect(cr, w, h, (beautiful.client_radius or 0))
        end
    end)

    naughty.connect_signal("request::display", function (n)
        naughty.layout.box { notification = n }
    end)
end

return M