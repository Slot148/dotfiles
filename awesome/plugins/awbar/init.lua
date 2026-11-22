local utils = require("utils")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")

local M = {
    name        = "awbar",
    description = "a custom status bar",
    version     = "1.0"
}

local function make_section(widgets, config, side)
    local path = "plugins.awbar.widgets."
    local section = {
        layout = wibox.layout.fixed[config.orientation]
    }

    if widgets and #widgets > 0 then

        for _, wname in ipairs(widgets) do
            local ok, factory = pcall(require, path .. wname)

            if not ok then
                naughty.notification {
                    urgency = "critical",
                    title   = "awbar_plus: widget desconhecido",
                    message = string.format(
                        "O widget '%s' (seção %s) não existe em ./plugins/awbar/widgets",
                        tostring(wname), side
                    )
                }
                goto continue
            end

            if factory and type(factory) ~= "function" then
                naughty.notification {
                    urgency = "critical",
                    title   = "awbar_plus: widget invalido",
                    message = string.format(
                        "O widget '%s' (seção %s) não possui um formato valido",
                        tostring(wname), side
                    )
                }
                goto continue
            end

            section[#section+1] = factory(config)

            ::continue::
        end
    end

    return section
end

function M.setup(core)
    core.registry.awbar = {}

    local settings = core.settings.awbar or {}
    local registry = core.registry.awbar

    local function apply(s)
        for _, bar in ipairs(settings) do
            registry[bar.name] = utils.container.awbar {
                screen   = bar.screen   or s,
                margin   = bar.margin   or (beautiful.useless_gap or 0) // 2,
                round    = bar.round    or (beautiful.client_radius or 0) // 2,
                height   = bar.height   or 20,
                width    = bar.width    or 100,
                align    = bar.align    or "centered",
                stretch  = bar.stretch,
                position = bar.position or "top",
                bg       = bar.bg       or beautiful.bg_normal
            }

            local orientation = "horizontal"
            local direction   = "north"

            if bar.position == "left" then
                orientation = "vertical"
                direction   = "east"
            elseif bar.position == "right" then
                orientation = "vertical"
                direction   = "west"
            end

            local widgets = bar.widgets
            local config  = {
                screen       = bar.screen or s,
                bar_settings = bar,
                dir          = core.dir,
                orientation  = orientation,
                direction    = direction,
                modkey       = core.settings.modkey
            }

            if widgets then
                registry[bar.name]:setup {
                    {
                        make_section(widgets.left, config, "left"),
                        make_section(widgets.center, config, "center"),
                        make_section(widgets.right, config, "right"),
                        layout = wibox.layout.align[config.orientation],
                        expand = bar.expand or "none"
                    },
                    margins = bar.padding or 2,
                    widget = wibox.container.margin
                }
            end
        end
    end

    local screen = _G["screen"]
    screen.connect_signal("request::desktop_decoration", apply)
end

return M