#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru

if [ "X${WOW}X" == "XX" ]
then
    feh --bg-scale '.config/awesome/bg.xpm'
    while true
    do
        #xsetroot -name "`dstat 1 1`" -bg "#222222"
        sleep 5
    done &
    dwm
else
    wine ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/Wow.exe
fi

