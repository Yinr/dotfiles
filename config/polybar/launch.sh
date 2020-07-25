#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')
export MONITOR=${MONITOR:-$(xrandr | sed -En '/connected primary/s/^([^ ]+).*/\1/p')}

export TEMP_HWMON_PATH=$(ls /sys/devices/platform/coretemp.0/hwmon/hwmon*/temp1_input|head -1)

dev_net="$(printf '%s\n' /sys/class/net/*/device | awk -F'/' '{ print $5 }')"
dev_wl="$(printf '%s\n' /sys/class/net/*/wireless | awk -F'/' '{ print $5 }' | head -1)"
dev_net=$(echo "${dev_net}\n${dev_wl}\n${dev_wl}" | sort | uniq -u | head -1)

export DEVICE_ETHERNET="${dev_net}"
export DEVICE_WIRELESS="${dev_wl}"

polybar main &

echo "Bars launched..."
