#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru

xset r rate 300 50
xsetroot -solid "#444444"
xrdb -merge $HOME/.Xresources
wmname LG3D
export DWM_UPDATE_MARK=$(mktemp -u --suffix=.dwm)
while true
do
    sh $HOME/.dwm.update
    sleep 10
done &
autocutsel&
xcompmgr&
dbus-launch --exit-with-session dwm

