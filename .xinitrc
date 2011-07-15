#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru

if [ "X${WOW}X" == "XX" ]
then
    xsetroot -solid "#222222"
    top -b -d 10 -p 1 >/tmp/.cpuusage&
    while true
    do
        sh $HOME/.dwm.update
        sleep 10
    done &
    dwm
else
    wine ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/Wow.exe
fi

