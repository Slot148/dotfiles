pcall(require, "luarocks.loader")

local function bootstrap_path()
    local conffile = awesome.conffile
    if not conffile then
        return
    end
    
    local dir = conffile:match("^(.*)[/\\][^/\\]+$") or "."
    if not dir or dir == "" then
        return
    end
    
    package.path = dir .. "/?.lua;" .. dir .. "/?/init.lua;" .. package.path
end

bootstrap_path()

require("awful.autofocus")
require("core")