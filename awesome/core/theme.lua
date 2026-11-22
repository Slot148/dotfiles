local beaut = require("beautiful")
local gfs   = require("gears.filesystem")

local M = {}

local fallback = {
    bg_normal = "#222222",
    fg_normal = "#eeeeee",
    bg_focus  = "#535d6c",
    fg_focus  = "#ffffff",
    font      = "sans10",
}

function M.load()
    local settings   = _G.SETTINGS.theme
    local theme_name = settings.name or "default"
    local theme_dir  = (_G.CORE.dir or ".") .. "/themes/" .. theme_name
    local theme_file = theme_dir .. "/theme.lua"

    local ok = pcall(beaut.init, theme_file)
    if not ok or not beaut.bg_normal then
        beaut.init(gfs.get_themes_dir() .. "default/theme.lua")
    end

    for key, value in pairs(fallback) do 
        beaut[key] = beaut[key] or value
    end
end

return M