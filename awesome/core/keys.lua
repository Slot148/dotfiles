local awful   = require("awful")
local naughty = require("naughty")
local awesome = _G.awesome

local utils   = require("utils")
local hotkeys_popup = require("awful.hotkeys_popup")

local M = {}

function M.load()
    local settings     = _G.SETTINGS or {}
    local modkey       = settings.modkey or "Mod4"
    local apps         = settings.apps or {}

    local terminal = apps.terminal or "x-terminal-emultator"

    local ctrl = "Control"
    local shft = "Shift"

    local function run_prompt()
        local s = awful.screen.focused()
        if s and s.promptbox then
            s.promptbox:run()
        else
            naughty.notification {
                urgency = "normal",
                message = "promptbox isn't defined on the screen"
            }
        end
    end

    ---------------------------
    --- Global Key Bindings ---
    ---------------------------
    awful.keyboard.append_global_keybindings({
        group = "awesome",
        awful.key({ modkey, ctrl }, "r", function() awesome.restart() end, { description = "restart awesome" }),
        awful.key({ modkey, ctrl }, "q", function() awesome.quit()    end, { description = "quit awesome"    }),
    })

    awful.keyboard.append_global_keybindings({
        group = "launcher",
        awful.key({ modkey }, "Return", function() awful.spawn(apps.terminal)     end, { description = "open terminal"     }),
        awful.key({ modkey }, "e"     , function() awful.spawn(apps.file_manager) end, { description = "opem file manager" }),
        awful.key({ modkey }, "s"     , function() hotkeys_popup.show_help()      end, { description = "show key help"     }),
        awful.key({ modkey }, "r"     , function() run_prompt()                   end, { description = "run a command"     }),
    })

    awful.keyboard.append_global_keybindings({
        group = "tags",
        awful.key({ modkey }, "Left"  , awful.tag.viewprev       , { description = "view prev tag"    }),
        awful.key({ modkey }, "Right" , awful.tag.viewnext       , { description = "view next tag"    }),
        awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "back to prev tag" }),

        awful.key {
            modifiers   = { modkey }     ,
            keygroup    = "numrow"       ,
            description = "only view tag",
            on_press    = function (index)
                local screen = awful.screen.focused()
                local tag    = screen.tags[index]
                if tag then
                    tag:view_only()
                end
            end,
        },

        awful.key {
            modifiers   = { modkey, ctrl },
            keygroup    = "numrow"        ,
            description = "toggle tag"    ,
            on_press = function (index)
                local screen = awful.screen.focused()
                local tag    = screen.tags[index]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end
        },

        awful.key {
            modifiers   = { modkey, shft },
            keygroup    = "numrow"        ,
            description = "move cli to tag",
            on_press = function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end
        },

        awful.key {
            modifiers    = { modkey, ctrl, shft } ,
            keygroup     = "numrow"               ,
            description  = "toggle focused client",
            on_press     = function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end
        },

        awful.key {
            modifiers   = { modkey }              ,
            keygroup    = "numpad"                ,
            description = "select layout directly",
            on_press    = function (index)
                local t = awful.screen.focused().selected_tag
                if t then
                    t.layout = t.layout[index] or t.layout
                end
            end
        }
    })

    awful.keyboard.append_global_keybindings({
        group = "client",
        awful.key({ modkey }, "j"  , function () awful.client.focus.byidx(1)  end, { description = "focus next client" }),
        awful.key({ modkey }, "k"  , function () awful.client.focus.byidx(-1) end, { description = "focus prev client" }),

        awful.key({ modkey }, "Tab", function ()
            awful.client.focus.history.previous()

            if client.focus then
                client.focus:raise()
            end
        end, { description = "back to prev client"}),

        awful.key({ modkey, ctrl }, "n", function()
            local c = awful.client.restore()

            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
         end, { description = "restore minimized client"}),

        awful.key({ modkey, shft }, "j", function() awful.client.swap.byidx(1)  end, { description = "switch with the next client" }),
        awful.key({ modkey, shft }, "k", function() awful.client.swap.byidx(-1) end, { description = "switch with the prev client" }),
        awful.key({ modkey,      }, "u", awful.client.urgent.jumpto                , { description = "switch to urgent client"     }),
    })

    awful.keyboard.append_global_keybindings({
        group = "layout",
        awful.key({ modkey,      }, "h"    , function() awful.tag.incmwfact(-0.05)          end, { description = "decrease master width"   }),
        awful.key({ modkey,      }, "l"    , function() awful.tag.incmwfact(0.05)           end, { description = "increase master width"   }),
        awful.key({ modkey, shft }, "h"    , function() awful.tag.incnmaster(1, nil, true)  end, { description = "increase num of masters" }),
        awful.key({ modkey, shft }, "l"    , function() awful.tag.incnmaster(-1, nil, true) end, { description = "decrease num of masters" }),
        awful.key({ modkey, ctrl }, "h"    , function() awful.tag.incncol(1, nil, true)     end, { description = "increase num of cols"    }),
        awful.key({ modkey, ctrl }, "l"    , function() awful.tag.incncol(-1, nil, true)    end, { description = "decrease num of cols"    }),
        awful.key({ modkey,      }, "space", function() awful.layout.inc(1)                 end, { description = "select next layout"      }),
        awful.key({ modkey, ctrl }, "space", function() awful.layout.inc(-1)                end, { description = "select prev layout"      }),
    })

    awful.keyboard.append_global_keybindings({
        group = "control",
        awful.key({ }, "XF86Tools"           , function() end, { description = "" }),
        awful.key({ }, "XF86AudioRaiseVolume", function() end, { description = "" }),
        awful.key({ }, "XF86AudioLowerVolume", function() end, { description = "" }),
        awful.key({ }, "XF86AudioMute"       , function() end, { description = "" }),
        awful.key({ }, "XF86AudioStop"       , function() end, { description = "" }),
        awful.key({ }, "XF86AudioPrev"       , function() end, { description = "" }),
        awful.key({ }, "XF86AudioNext"       , function() end, { description = "" }),
        awful.key({ }, "XF86AudioPlay"       , function() end, { description = "" }),
        awful.key({ }, "XF86Mail"            , function() end, { description = "" }),
        awful.key({ }, "XF86HomePage"        , function() end, { description = "" }),
        awful.key({ }, "XF86Calculator"      , function() end, { description = "" }),
    })

    if utils.tags then
        awful.keyboard.append_global_keybindings({
            group = "tags",
            awful.key({ modkey,      }, "=", function() utils.tags.increase()  end, { description = "add new tag"          }),
            awful.key({ modkey, shft }, "=", function() utils.tags.new_named() end, { description = "add new named tag"    }),
            awful.key({ modkey, ctrl }, "=", function() utils.tags.rename()    end, { description = "rename current tag"   }),
            awful.key({ modkey,      }, "-", function() utils.tags.decrease()  end, { description = "del last tag"         }),
            awful.key({ modkey, ctrl }, "-", function() utils.tags.delete()    end, { description = "del current tag"      }),
        })
    end

    -----------------------------
    --- Global Mouse Bindings ---
    -----------------------------
    awful.mouse.append_global_mousebindings({
        awful.button({ }, 4, awful.tag.viewprev),
        awful.button({ }, 5, awful.tag.viewnext),
        awful.button({ }, 3, function()     end), -- menu
    })

    -----------------------------
    --- Client Mouse Bindings ---
    -----------------------------
    client.connect_signal("request::default_mousebindings", function()
        awful.mouse.append_client_mousebindings({
            awful.button({        }, 1, function (c)
                c:activate { context = "mouse_click" }
            end),
            awful.button({ modkey }, 1, function (c)
                c:activate { context = "mouse_click", action = "mouse_move"   }
            end),
            awful.button({ modkey }, 3, function (c)
                c:activate { context = "mouse_click", action = "mouse_resize" }
            end)
        })
    end)

    ---------------------------
    --- Client Key Bindings ---
    ---------------------------
    client.connect_signal("request::default_keybindings", function ()

        awful.keyboard.append_client_keybindings({
            group = "client",
            
            awful.key({ modkey       }, "f"     , function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end, { description = "toggle fullscreen" }),

            awful.key({ modkey, shft }, "c"     , function (c) c:kill()                                            end, { description = "close client"                   }),
            awful.key({ modkey, ctrl }, "Return", function (c) c:swap(awful.client.getmaster())                    end, { description = "move to master"                 }),
            awful.key({ modkey,      }, "o"     , function (c) c:move_to_screen()                                  end, { description = "move to screen"                 }),
            awful.key({ modkey,      }, "t"     , function (c) c.ontop = not c.ontop                               end, { description = "fix the client"                 }),
            awful.key({ modkey       }, "n"     , function (c) c.minimized = true                                  end, { description = "minimize client"                }),

            awful.key({ modkey       }, "m"     , function (c)
                c.maximized = not c.maximized
                c:raise()
            end, { description = "maximize client" }),
            
            awful.key({ modkey, ctrl }, "m", function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end, { description = "maximize client vertically" }),

            awful.key({ modkey, shft }, "m", function (c)
                c.maximized_horizontal = not c.maximized_horizontal 
                c:raise()
            end, { description = "maximize client horizontally" }),

            awful.key({ modkey, shft }, "space",  awful.client.floating.toggle, { description = "toggle floating" }),

        })
    end)
end

return M