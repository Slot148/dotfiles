local naughty = require("naughty")
local awful   = require("awful")

local M = {}

function M.save(args)
    local screenshot = awful.screenshot(args)
    local function notify(self)
        naughty.notification {
            title     = "Screeshot Saved",
            message   = self.file_name,
            icon      = self.surface,
            icon_size = 128
        }
    end

    if args.auto_save_delay > 0 then
        screenshot:connect_signal("file::saved", notify)
    else
        notify(screenshot)
    end
end

return M