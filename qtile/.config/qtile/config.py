# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import os
import subprocess
import xrp


# --- Function definitions ---
def xresget(xres, key, fallback):
    try:
        return xres.resources[key]
    except KeyError:
        return fallback


@lazy.function
def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i-1].group.name
        qtile.current_window.togroup(group)


@lazy.function
def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i+1].group.name
        qtile.current_window.togroup(group)


@lazy.function
def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i-1].group
    qtile.current_screen.set_group(group)


# --- Colors ---
xresources = xrp.parse_file(
    '{}/.Xresources'.format(os.path.expanduser('~')),
    encoding='utf8'
)
colors = {
    'fg':    xresget(xresources, '*.foreground', '#FFFFFF'),
    'selfg': xresget(xresources, '*.foreground', '#FFFFFF'),
    'bg':    xresget(xresources, '*.background', '#000000'),
    'selbg': xresget(xresources, '*.color8',     '#1050A0'),
}

# --- Defaults ---
mod = "mod4"
terminal = guess_terminal()
home = os.path.expanduser('~')

# --- Keyboard and Mouse shortcuts ---
keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "k",
        lazy.layout.down(),
        desc="Move focus down in stack pane"
    ),
    Key(
        [mod], "j",
        lazy.layout.up(),
        desc="Move focus up in stack pane"
    ),

    # Move windows up or down in current stack
    Key(
        [mod, "shift"], "k",
        lazy.layout.shuffle_down(),
        desc="Move window down in current stack"
    ),
    Key(
        [mod, "shift"], "j",
        lazy.layout.shuffle_up(),
        desc="Move window up in current stack"
    ),

    # Move windows between screens
    Key(
        [mod, "shift", "control"], "j",
        window_to_previous_screen,
        desc="Move window to the previous screen"
    ),
    Key(
        [mod, "shift", "control"], "k",
        window_to_next_screen,
        desc="Move window to th next screen"
    ),

    # Rotate screens
    Key(
        [mod, "shift", "control"], "space",
        switch_screens,
        desc="Rotate screens"
    ),

    # Toggle between different layouts as defined below
    Key(
        [mod, "control"], "comma",
        lazy.prev_layout(),
        desc="Toggle between layouts"
    ),
    Key(
        [mod, "control"], "period",
        lazy.next_layout(),
        desc="Toggle between layouts"
    ),

    # Kill window
    Key(
        [mod, "shift"], "c",
        lazy.window.kill(),
        desc="Kill focused window"
    ),

    # Sound and Power
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Lower volume"
    ),
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Raise volume"
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("sh -c 'pactl set-sink-mute @DEFAULT_SINK@ toggle'"),
        desc="Mute"
    ),
    Key(
        [], "XF86PowerOff",
        lazy.spawn("powermenu"),
        desc="Powermenu"
    ),

    # Launch terminal and other programs
    Key(
        [mod], "Return",
        lazy.spawn(terminal),
        desc="Launch terminal"
    ),
    Key(
        [mod, "shift"], "Return",
        lazy.spawn("rofi -show drun -show-icons"),
        desc="Launch rofi -show drun"
    ),
    Key(
        [mod, "shift", "control"], "Return",
        lazy.spawn("rofi -show run"),
        desc="Launch rofi -show run"
    ),
    Key(
        [mod], "c",
        lazy.spawn("clipmenu -p 'Clip:'"),
        desc="Launch clipmenu"
    ),

    # Restart/Close qtile
    Key(
        [mod, "shift", "control"], "q",
        lazy.restart(),
        desc="Restart qtile"
    ),
    Key(
        [mod, "shift"], "q",
        lazy.shutdown(),
        desc="Shutdown qtile"
    ),
    Key(
        [mod], "r",
        lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag(
        [mod], "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()
    ),
    Click(
        [mod], "Button2",
        lazy.window.bring_to_front()
    )
]

# --- Groups ---
group_names = [
    ('1', {'layout': 'monadtall'}),
    ('2', {'layout': 'monadtall'}),
    ('3', {'layout': 'monadtall'}),
    ('4', {'layout': 'monadtall'}),
    ('5', {'layout': 'monadtall'}),
    ('6', {'layout': 'monadtall'}),
    ('7', {'layout': 'monadtall'}),
    ('8', {'layout': 'monadtall'})
]

groups = [Group(i, **kwargs) for i, kwargs in group_names]

for i in groups:
    keys.extend([
        Key(
            [mod], i.name,
            lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)
        ),
        Key(
            [mod, "shift"], i.name,
            lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)
        ),
    ])

# --- Layouts ---
layout_theme = {
    "border_width": 1,
    "margin": 2,
    "border_focus": colors['fg'],
    "border_normal": colors['bg']
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Columns(),
    layout.Matrix(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# --- Widgets ---
widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

widget_list = [
    widget.CurrentLayoutIcon(),
    widget.GroupBox(
        borderwidth=1,
        rounded=False,
        hide_unused=True,
        foreground=colors['fg'],
        highlight_method='line',
        highlight_color=[colors['selbg'], colors['selbg']],
        urgent_alert_method='line',
        urgent_text=colors['bg'],
        urgent_border=colors['fg']),
    widget.Prompt(),
    widget.WindowName(),
    widget.Systray(),
    widget.Clock(
        format='%H:%M',
        mouse_callbacks={'Button1': lambda qtile: qtile.cmd_spawn('gsimplecal')})
]

# --- Screens ---
screens = [
    Screen(
        bottom=bar.Bar(
            widget_list,
            20,
            background=colors['bg'])),
]

# --- Rules and Settings ---
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'gsimplecal'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

class_group = {
    'Firefox': '8',
    'qutebrowser': '8'
}


# --- Hooks ---
@hook.subscribe.client_new
def to_group(window):
    wm_class = window.cmd_inspect()['wm_class']
    for wmc in wm_class:
        if wmc in class_group.keys():
            window.cmd_togroup(class_group[wmc])
            break


@hook.subscribe.startup
def start():
    subprocess.call(['{}/.config/qtile/autostart.sh'.format(home)])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
