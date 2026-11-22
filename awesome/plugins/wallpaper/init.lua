local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local gears     = require("gears")

local M = {
    name = "Wallpaper Plugin",
    description = "Desktop Wallpaper and watermark Plugin"
}

function M.setup(core)
    local settings = core.settings.wallpaper or {}
    local image    = settings.image

    if image and not gears.filesystem.file_readable(image) then
        gears.debug.print_warning(
            ("wallpaper: '%s' não existe ou não pode ser lido; usando o tema."):format(tostring(image))
        )
        image = nil
    end

    image = image or beautiful.wallpaper

    local watermark = settings.watermark ~= false
    local icon_path = core.dir .. "/themes/assets/awesome.svg"

    local function apply(s)
        local manual = wibox.layout.manual()

        if watermark and gears.filesystem.file_readable(icon_path) then
            local icon = wibox.widget {
                image         = gears.color.recolor_image(icon_path, beautiful.bg_normal),
                resize        = true,
                widget        = wibox.widget.imagebox
            }

            manual:add_at(icon, {
                x = s.geometry.width  - 80,
                y = s.geometry.height - 70,
                height = 60,
                width  = 60,
            })
        end

        awful.wallpaper {
            screen = s,
            bg     = beautiful.bg_normal,
            -- widget = {
            --     {
            --         {
            --             {
            --                 image                 = image,
            --                 valign                = "center",
            --                 halign                = "center",
            --                 horizontal_fit_policy = "fit",
            --                 vertical_fit_policy   = "fit",
            --                 widget                 = wibox.widget.imagebox,
            --                 clip_shape = function (cr, w, h)
            --                     gears.shape.rounded_rect(cr, w, h, 8)
            --                 end
            --             },
            --             widget = wibox.container.margin,
            --             margins = {
            --                 top = 35,
            --                 bottom = 10,
            --                 left = 10,
            --                 right = 10
            --             },
            --         },
            --         widget = wibox.container.background,
            --         bg = beautiful.bg_normal
            --     },
            --     manual,
            --     layout = wibox.layout.stack
            -- },

            widget = {
                {
                    image = image,
                    valign = "center",
                    halign = "center",
                    horizontal_fit_policy = "fit",
                    vertical_fit_policy = "fit",
                    widget = wibox.widget.imagebox
                },
                manual,
                layout = wibox.layout.stack
            }
        }
    end

    screen.connect_signal("request::wallpaper", apply)
end

return M