local naughty = require("naughty")
local gfs     = require("gears.filesystem")

local CORE = {}

CORE.dir = (gfs.get_configuration_dir() or "./"):gsub("/$", "")
if CORE.dir == "" then
  CORE.dir = "."
end

CORE.settings = require("core.settings")

CORE.registry = {}

_G.CORE     = CORE
_G.SETTINGS = CORE.settings

naughty.connect_signal("request::display_error", function (message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened" .. (startup and " during startup" or "!"),
        message = message
    }
end)

CORE._VERSION = "1.0"

CORE.theme = require("core.theme")
CORE.theme.load()

CORE.tags = require("core.tags")
CORE.tags.load()

CORE.keys = require("core.keys")
CORE.keys.load()

CORE.rules = require("core.rules")
CORE.rules.load()

CORE.signals = require("core.signals")
CORE.signals.load()

CORE.plugins = require("core.plugins")
CORE.plugins.load()


return CORE