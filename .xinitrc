#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru
xset s off -dpms +fp /usr/share/fonts/terminus

if [ "X${WOW}X" == "XX" ]
then
    xsetroot -solid "#222222"
    top -b -d 10 -p 1 >/tmp/.cpuusage&
    trayer --edge top --height 16 --widthtype pixel --width 66 --align right --alpha 220 --transparent true&
    while true
    do
        sh $HOME/.dwm.update
        sleep 10
    done &
    dwm
else
    wine ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/Wow.exe
fi

