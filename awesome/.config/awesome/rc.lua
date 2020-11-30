-- {{{ Error handling
require("require.errors")
-- }}}

-- {{{ Variable definitions
require("require.env")
-- }}}

-- {{{ Menu
require("require.menu")
-- }}}

-- {{{ Wibar
require("require.wibar")
-- }}}

-- {{{ Mouse bindings
require("require.mouse-bindings")
-- }}}

-- {{{ Key bindings
require("require.key-bindings")
-- }}}

-- {{{ Rules
require("require.rules")
-- }}}

-- {{{ Signals
require("require.signals")
-- }}}

-- {{{ Autostart
local awful = require("awful")
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
-- }}}
