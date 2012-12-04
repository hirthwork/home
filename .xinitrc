#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru

if [ "X${WOW}X" == "XX" ]
then
    xset r rate 300 50
    xset +fp /usr/share/fonts/terminus
    xsetroot -solid "#000000"
    xrdb -merge $HOME/.Xresources
    top -b -d 10 -p 1 >/tmp/.cpuusage&
    trayer --edge bottom --height 16 --widthtype pixel --width 66 --align right --alpha 255 --transparent true&
    wmname LG3D
    while true
    do
        sh $HOME/.dwm.update
        sleep 10
    done &
    dwm
else
    wine ~/.wine/drive_c/Program\ Files/World\ of\ Warcraft/Wow.exe
fi

