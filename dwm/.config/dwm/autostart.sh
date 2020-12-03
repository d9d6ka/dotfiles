#!/usr/bin/env bash

function run {
    tmp=$(basename -- $1)
    pgrep -x $tmp > /dev/null
    if [ $? -eq 1 ]
    then
        $@ &
    fi
}

# Low-level X apps preferences
xrdb -merge ~/.Xresources

# Mate Polkit Agent
run /usr/libexec/polkit-mate-authentication-agent-1

# Notifications
run dunst &

# Compositor
run compton -b

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

# Statusbar
run dwmblocks

