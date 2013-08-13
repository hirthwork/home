#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru
xmodmap -e "keycode 36 = Return bar"

if [ "X${WOW}X" == "XX" ]
then
    xset r rate 300 50
    xsetroot -solid "#444444"
    xrdb -merge $HOME/.Xresources
    top -b -d 10 -p 1 >/tmp/.cpuusage&
    trayer --tint 0x444444 --edge top --height 16 --widthtype pixel --width 66 --align right --transparent true&
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

