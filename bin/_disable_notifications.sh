#!/usr/bin/env bash

if [ "$#" != "0" ] && [ "$1" == "-n" ]; then
    /usr/bin/notify-send "Pausing notifications"
fi

/bin/sleep 5
if [ -e /usr/local/bin/dunstctl ]; then
    /usr/local/bin/dunstctl set-paused true
else
    /usr/bin/notify-send "DUNST_COMMAND_PAUSE"
fi
