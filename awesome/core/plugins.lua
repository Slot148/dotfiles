local naughty = require("naughty")

local M = {
    loaded = {},
    failed = {},
    order  = {},
}

local function report(name, err)
    naughty.notification {
        urgency = "critical",
        title   = "Plugin failed: " .. name,
        message = tostring(err)
    }
end

function M.attach(name)
    if M.loaded[name] then
        return true
    end

    local ok, module = pcall (require, "plugins." .. name)
    if not ok then
        M.failed[name] = tostring(module)
        report(name, module)
        return false
    end

    if type(module) == "table" and module.setup then
        local sok, serr = pcall(module.setup, _G.CORE)
        if not sok then
            M.failed[name] = tostring(serr)
            report(name, serr)
            return false
        end
    end

    M.loaded[name] = module
    M.order[#M.order+1] = name
    return true
end

function M.detach(name)
    M.loaded[name] = nil
    M.failed[name] = nil
    for i = #M.order, 1, -1 do
        if M.order[i] == name then
            table.remove(M.order, i)
        end
    end
end

function M.load()
    local list = (_G.SETTINGS and _G.SETTINGS.plugins) or {}
    for _, name in ipairs(list) do
        M.attach(name)
    end
end

return M