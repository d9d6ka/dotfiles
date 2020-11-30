#!/bin/bash

packages() {
    local packagesnew=$(xbps-install -Mun | grep 'update' | wc -l)
    local label="📦"
    printf "%s %s\n" "$label" "$packagesnew"
}

volume() {
    local volstat=$(pacmd list-sinks | sed -n -e '/index/p;/base volume/d;/volume:/p;/muted:/p;/device\\.string/p')
    echo "$volstat" | grep -n "muted: yes" > /dev/null && printf "🔇\n" && exit
    local vol=$(echo "$volstat" | grep -o "[0-9]\+%" | sed "s/[^0-9]*//g;1q")
    [ ! "$vol" ] && printf "🔉\n" && exit
    if [ "$vol" -gt "70" ]; then
    	local icon="🔊"
    elif [ "$vol" -lt "30" ]; then
    	local icon="🔈"
    else
    	local icon="🔉"
    fi
   printf "%s %s%%\n" "$icon" "$vol"
}

function displaytime {
    local H=$(($1/60/60%24))
    local M=$(($1/60%60))
    printf '(%02d:%02d)' $H $M
}

battery() {
    [[ $(cat /sys/class/power_supply/AC0/online) -ne 0 ]] && printf "🔌"
    
    for bat in /sys/class/power_supply/BAT? ; do
        local capacity=$(cat "$bat"/capacity)
        local charge=$(( $(cat "$bat"/charge_now) * 3600 ))
        local current=$(cat "$bat"/current_now)
        local bstatus=$(cat "$bat"/status)
        case "$bstatus" in
            "Discharging") icon="🔋" ;;
            "Charging") icon="⚡" ;;
            "Unknown") icon="?" ;;
            "Full"|"Charged") icon="" ;;
            *) icon="" ;;
        esac
        [ "$icon" != "" ] && printf "%s " "$icon"
        [ "$capacity" != "" ] && printf "%s%%" "$capacity"
        [ $(cat /sys/class/power_supply/AC0/online) -eq 0 ] && printf " %s\n" $(displaytime $(($charge/$current)) ) || printf "\n"
    done
}

SLEEP_SEC=5

while :; do
    pgrep pulseaudio > /dev/null || pulseaudio -D
    echo "$(packages) | $(volume) | $(battery)"
    sleep $SLEEP_SEC
done

