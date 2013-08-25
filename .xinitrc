#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru
xmodmap -e "keycode 36 = Return bar"

if [ "X${WOW}X" == "XX" ]
then
    xset r rate 300 50
    xsetroot -solid "#444444"
    export DWM_CPU_USAGE=$(mktemp --suffix=.cpuusage)
    top -b -d 10 -p 1 > $DWM_CPU_USAGE &
    trayer --tint 0x444444 --edge top --height 16 --widthtype pixel --width 66 --align right --transparent true&
    wmname LG3D
    export DWM_UPDATE_MARK=$(mktemp -u --suffix=.dwm)
    while true
    do
        sh $HOME/.dwm.update
        sleep 10
    done &
    dwm
    rm -f $DWM_CPU_USAGE
else
    wine ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/Wow.exe
fi

