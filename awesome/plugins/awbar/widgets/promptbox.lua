local awful = require("awful")
local wibox = require("wibox")

local function promptbox(config)
    config = config or {}

    local promptbox = awful.widget.prompt()

    if config.screen then
        config.screen.promptbox = promptbox
    end

    return wibox.widget {
        promptbox,
        widget = wibox.container.margin,
    }
end

return promptbox