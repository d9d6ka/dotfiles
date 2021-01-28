#!/usr/bin/env sh

run () {
    pgrep -f $(basename -- $1)
    if [ $? -eq 1 ]; then
        "$@" &
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

# Statusbar
if [ "$DESKTOP_SESSION" = "dwm" ]; then
    run dwmblocks
fi
if [ "$DESKTOP_SESSION" = "xmonad" ]; then
    hlt trayer
    run trayer --edge top --align right --widthtype request --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x282c34  --height 16
    [ -e "/tmp/i3status.pipe" ] || mkfifo /tmp/i3status.pipe
    hlt i3status
    i3status > /tmp/i3status.pipe &
fi

# Notifications
run dunst

# Compositor
run compton -b

# NetworkManager applet
run nm-applet

# PowerManager applet
hlt xautolock
run xautolock -detectsleep -time ${IDLE_LOCK:-10} -locker "${IDLE_LOCKER:-i3lock-fancy -n}" -killtime ${IDLE_KILL:-20} -killer "${IDLE_KILLER:-sudo zzz}"

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

