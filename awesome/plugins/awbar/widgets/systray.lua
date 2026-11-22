local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function systray(config)
    beautiful.systray_icon_spacing = 5
	local systray = wibox.widget {
		{
			{
				widget = wibox.widget.systray(),
			},
			widget = wibox.container.margin,
			margins = { left = 2, right = 2 }
		},
		widget = wibox.container.background,
		bg = beautiful.bg_normal,
		fg = beautiful.fg_focus,
	}
	
	return { systray, widget = wibox.container.rotate, direction = config.direction }
end

return systray