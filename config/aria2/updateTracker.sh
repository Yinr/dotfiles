#!/bin/bash

trackers_url="https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt"
aria2_conf="$HOME/.config/aria2/aria2.conf"

trackers="$(curl -s "${trackers_url}" | \
    sed '/^$/d' | \
    tr '\n' ',' | \
    sed 's/,$//; s/^\(.*\)/bt-tracker=\1/')"
echo "${trackers}"

if [[ -z "${trackers}" ]]; then exit 1; fi

sed -i '/^bt-tracker=.*$/d' "${aria2c_conf}"
echo "${trackers}" >> "${aria2c_conf}"

