#!/bin/sh
setxkbmap -option grp:caps_toggle,compose:menu,compose:prsc,grp_led:scroll us,ru
xset r rate 300 50
xsetroot -solid "#444444"
xrdb -merge $HOME/.Xresources
wmname LG3D
export DWM_UPDATE_MARK=$(mktemp -u --suffix=.dwm)
export DWM_CPU_USAGE=$(mktemp --suffix=.cpuusage)
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS="@im=none"
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export LANG=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.utf8
while true
do
    sh $HOME/.dwm.update
    sleep 10
done &
autocutsel&
dbus-launch --exit-with-session dwm

