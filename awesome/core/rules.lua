local awful = require("awful")
local ruled = require("ruled")

local M = {}

function M.load()
    local settings = _G.SETTINGS or {}

    ruled.client.connect_signal("request::rules", function ()

        ruled.client.append_rules {
            {
                id         = "global",
                rule       = {},
                properties = {
                    focus     = awful.client.focus.filter,
                    raise     = true,
                    screen    = awful.screen.preferred,
                    placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                }
            },
            {
                id = "floating",
                rule_any = {
                    instance = { "copyq", "pinentry" },
                    class    = {
                        "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                        "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
                    },
                    name     = { "Event Tester" },
                    role     = { "AlarmWindow", "ConfigManager", "pop-up" },
                },
                properties = { floating = true }
            }

        }
        
        if settings.rules and #settings.rules > 0 then
            ruled.client.append_rules(settings.rules)
        end

    end)
end

return M