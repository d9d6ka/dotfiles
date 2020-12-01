#!/usr/bin/env bash

function run {
    tmp=$(basename -- $1)
    pgrep -x $tmp > /dev/null
    if [ $? -eq 1 ]; then
        $@ &
    fi
}

function hlt {
    tmp=$(basename -- $1)
    pgrep -x $tmp > /dev/null
    if [ $? -eq 0 ]; then
        for i in $(pidof $tmp); do
            kill $i
        done
        sleep 1
    fi
}

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

