#!/bin/bash

function run {
    tmp=$(basename -- $1)
    pgrep -x $tmp > /dev/null
    if [ $? -eq 1 ]
    then
        $@ &
    fi
}

run compton -b
run nm-applet
run udiskie --tray
run /usr/libexec/xfce-polkit
run clipmenud
run setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle
run xxkb
