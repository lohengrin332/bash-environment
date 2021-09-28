#!/usr/bin/env bash

if [ "$#" != "0" ] && [ "$1" == "-n" ]; then
    /usr/bin/notify-send "Pausing notifications"
fi

/bin/sleep 5
/usr/bin/notify-send "DUNST_COMMAND_PAUSE"
