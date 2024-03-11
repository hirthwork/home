#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,compose:prsc,grp_led:scroll us,ru
xset r rate 300 50
xsetroot -solid "#444444"
xrdb -merge $HOME/.Xresources
export DWM_CPU_USAGE=$(mktemp --suffix=.cpuusage)
export LANG=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.utf8
while true
do
    sh $HOME/.dwm.update
    sleep 10
done &
autocutsel&

if which skotty >/dev/null
then
    skotty start --daemonize
fi
nm-applet&
dbus-launch --exit-with-session dwm

