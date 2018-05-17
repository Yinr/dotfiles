#!/bin/bash
#
# touchpad setting
#

device=$(xinput list | grep -i touchpad)
deviceID=$(echo ${device} | sed -E "s/^.*\sid=([0-9]+)\s.*/\1/")

tp_status() {
    local deviceStats

    deviceStats=$(xinput list-props ${deviceID} | grep -i "Device Enabled" | cut -d":" -f 2)
    deviceStats=$(echo ${deviceStats} | grep -o "[0-9]")

    case "${deviceStats}" in
        "0")
            echo "off";;
        "1")
            echo "on";;
        *)
            echo "";;
    esac
}

tp_enable() {
    xinput enable ${deviceID}
}

tp_disable() {
    xinput disable ${deviceID}
}

tp_toggle() {
    local status
    status=$(tp_status)

    case "${status}" in
        "on")
            tp_disable;;
        "off")
            tp_enable;;
        *)
            exit 1;;
    esac
}

usage() {
    local scriptName=$(basename $0)
    echo "usage: ${scriptName} status|enable|disable|toggle"
}

case "$1" in
    "status" | "")
        tp_status;;
    "enable" | "on")
        tp_enable;;
    "disable" | "off")
        tp_disable;;
    "toggle")
        tp_toggle;;
    *)
        usage;;
esac
