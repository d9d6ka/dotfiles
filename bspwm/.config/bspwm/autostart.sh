#!/usr/bin/env bash

function run {
    tmp=$(basename -- $1)
    pgrep -x $tmp > /dev/null
    if [ $? -eq 1 ]; then
        $@ &
    fi
}

# Hotkey daemon
run sxhkd

# Low-level X apps preferences
run xrdb -merge ~/.Xresources

# Mate Polkit Agent
run /usr/libexec/polkit-mate-authentication-agent-1

# Notifications
run dunst &

# Compositor
run compton -b

# Polybar
~/.config/polybar/launch.sh

# NetworkManager applet
run nm-applet

# Clipboard manager
run clipmenud

# Keyboard layouts
run setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle
killall xxkb
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
killall bspswallow
run bspswallow

