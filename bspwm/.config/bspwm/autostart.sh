#!/usr/bin/env bash

function run {
    pgrep -f $(basename -- $1)
    if [ $? -eq 1 ]; then
        $@ &
    fi
}

function hlt {
    for i in $(pgrep -f $(basename -- $1)); do
        kill $i
    done
}

# Hotkey daemon
run sxhkd

# Low-level X apps preferences
run xrdb -merge ~/.Xresources

# Mate Polkit Agent
run /usr/libexec/polkit-mate-authentication-agent-1

# Notifications
run dunst

# Compositor
run compton -b

# Polybar
hlt polybar
~/.config/polybar/launch.sh

# NetworkManager applet
run nm-applet

# Clipboard manager
run clipmenud

# Keyboard layouts
run setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle
hlt xxkb
run xxkb

# Wallpaper
run nitrogen --random --set-zoom-fill ~/.local/share/wallpapers

# Daemonise PCManFM
run pcmanfm -d

# Volume icon
run volctl

# Power manager
run mate-power-manager

# Bspswallow
hlt bspswallow
run bspswallow

