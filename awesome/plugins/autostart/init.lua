local awful = require("awful")

local M = {
    name = "autostart",
    description = "Start applications when load"
}

function M.setup(core)
    local settings = core.settings.autostart or {}
    if settings then
        for i, n in ipairs(settings) do
            awful.spawn.with_shell(n)
        end
    end
end

return M