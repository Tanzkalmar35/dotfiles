#/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
pkill i3bar
# killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Startet Polybar auf allen erkannten Monitoren
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload bar1 -c ~/.config/polybar/config.ini &
  done
else
  polybar --reload bar1 -c ~/.config/polybar/config.ini &
fi
