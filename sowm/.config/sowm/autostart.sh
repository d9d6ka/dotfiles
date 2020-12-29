#!/usr/bin/env sh

run () {
    pgrep -f $(basename -- $1)
    if [ $? -eq 1 ]; then
        $@ &
    fi
}

hlt () {
    for i in $(pgrep -f $(basename -- $1)); do
        kill $i
    done
}

setsid ./start.sh

# Low-level X apps preferences
run xrdb -merge ~/.Xresources
run xrdb -merge ~/.config/Xresources/Base16-Zenburn

# Mate Polkit Agent
run /usr/libexec/polkit-mate-authentication-agent-1

# Tray
run stalonetray

# Notifications
run dunst

# Compositor
run compton -b

# NetworkManager applet
run nm-applet

# Clipboard manager
hlt clipmenud
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

exec sowm
