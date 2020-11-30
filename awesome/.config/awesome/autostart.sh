#!/usr/bin/env bash

function run {
    tmp=$(basename -- $1)
    pgrep -x $tmp > /dev/null
    if [ $? -eq 1 ]
    then
        $@ &
    fi
}

run xrdb -merge ~/.Xresources
run compton -b
run nitrogen --random --set-zoom-fill ~/.local/share/wallpapers
run /usr/libexec/polkit-mate-authentication-agent-1
run nm-applet
run pcmanfm -d
run volctl
run mate-power-manager
run clipmenud
run setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle
run xxkb
