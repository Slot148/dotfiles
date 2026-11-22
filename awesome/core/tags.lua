local awful = require("awful")

local M = {}

local function default_layouts()
    return {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.spiral
    }
end

function M.load()
    local settings = _G.SETTINGS or {}
    local names    = settings.tags or {"1","2","3","4"}
    local layouts  = settings.layouts or default_layouts()

    local apended = false

    tag.connect_signal("request::default_layouts", function ()
        if apended then 
            return
        end

        apended = true
        awful.layout.append_default_layouts(layouts)
    end)

    screen.connect_signal("request::desktop_decoration", function (s)
        if s.tags and #s.tags > 0 then
            return
        end

        awful.tag(names, s, layouts[1])
    end)

end

return M