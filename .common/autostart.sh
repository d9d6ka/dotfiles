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

# Low-level X apps preferences
run xrdb -merge ~/.Xresources
run xrdb -merge ~/.config/Xresources/Nord

# Mate Polkit Agent
run /usr/libexec/polkit-mate-authentication-agent-1

# Notifications
run dunst

# Compositor
run compton -b

# NetworkManager applet
run nm-applet

# PowerManager applet
#run mate-power-manager
run xautolock -detectsleep

# Keyboard layouts
run setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle
hlt xxkb
run xxkb

# Clipboard manager
hlt clipmenud
run clipmenud

# Wallpaper
run nitrogen --random --set-zoom-fill ~/.local/share/wallpapers

# Daemonise PCManFM
run pcmanfm -d

# Statusbar
[ "$DESKTOP_SESSION" = "dwm" ] && run dwmblocks
