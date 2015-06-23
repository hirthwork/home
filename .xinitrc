#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,grp_led:scroll us,ru

xset r rate 300 50
xsetroot -solid "#444444"
xrdb -merge $HOME/.Xresources
export DWM_CPU_USAGE=$(mktemp --suffix=.cpuusage)
top -b -d 10 -p 1 > $DWM_CPU_USAGE &
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
rm -f $DWM_CPU_USAGE

