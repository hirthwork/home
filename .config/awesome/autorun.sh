#!/usr/bin/env bash
xrandr --output DP-1 --scale 0.5x0.5 --filter bilinear --same-as eDP-1
nm-applet&
parcellite&
xset r rate 300 50
xrdb -merge $HOME/.Xresources
ibus exit
sleep 5
for display in 0 1
do
    setxkbmap -display :$display -option grp:caps_toggle,compose:menu,compose:prsc,grp_led:scroll us,ru
done
