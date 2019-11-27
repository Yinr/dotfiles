#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

export MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')

dev_net="$(printf '%s\n' /sys/class/net/*/device | awk -F'/' '{ print $5 }')"
dev_wl="$(printf '%s\n' /sys/class/net/*/wireless | awk -F'/' '{ print $5 }')"

export DEVICE_ETHERNET="$(sort <(echo $dev_net) <(echo $dev_wl) <(echo $dev_wl)|uniq -u|head -1)"
export DEVICE_WIRELESS="$(echo $dev_wl|head -1)"

polybar main &

echo "Bars launched..."
