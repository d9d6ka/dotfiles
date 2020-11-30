-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Freedesktop menu
local freedesktop = require("freedesktop")

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
        { "Terminal", terminal, menubar.utils.lookup_icon("terminal") },
        -- { "Log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
        -- { "Sleep", "sleep 1 && sudo zzz", menubar.utils.lookup_icon("system-suspend") },
        -- { "Reboot", "sudo reboot", menubar.utils.lookup_icon("system-reboot") },
        -- { "Shutdown", "sudo shutdown -P now", menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
})

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                    { "open terminal", terminal }
--                                  }
--                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Helper function for quitmenu
local quitmenu = {
    { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "suspend", "sleep 1 && sudo zzz", menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", "sleep 1 && sudo ZZZ", menubar.utils.lookup_icon("system-hibernate") },
    { "reboot", "sudo reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "sudo shutdown -P now", menubar.utils.lookup_icon("system-shutdown") },
}

myquitmenu = awful.menu({items = quitmenu})

myquitlauncher = awful.widget.launcher({ image = menubar.utils.lookup_icon("system-shutdown"),
                                         menu = myquitmenu })
-- }}} 

