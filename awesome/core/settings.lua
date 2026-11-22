local home = os.getenv("HOME") or ""

local settings = {}

settings.modkey = "Mod4"

settings.theme = {
    name = "cottoncandy"
}

settings.dirs = {
    home      = home,
    pictures  = home .. "/Images",
    downloads = home .. "/Downloads",
}

settings.user = {
    name  = os.getenv("USER") or os.getenv("LOGNAME"),
    icon  = home .. "/.face"
}

settings.apps = {
    terminal     = "xterm",
    file_manager = "thunar",
    editor       = os.getenv("EDITOR") or "nano"
}

settings.tags = { "1", "2", "3", "4" }

settings.rules = {}

---------------
--- Plugins ---
---------------
settings.plugins = {
    "wallpaper",
    "awbar",
    "autostart",
    "menubar",
    "titlebar",
    "screenshots"

}

settings.wallpaper = {
    image = "/home/nicolas/Imagens/wallpapers/1311796.png",
    watermark = true
}

settings.awbar = {
    {
        name = "awbar",
        position = "left",
        widgets = {
            left   = { "layoutbox", "separator", "taglist", "separator", "promptbox" },
            center = { "textclock" },
            right  = { "systray", "separator", }
        }
    }
}

settings.titlebars = {
    enable = false
}

settings.autostart = {
    "picom &",
    "lxpolkit",
    "snixembed --fork"
}


return settings