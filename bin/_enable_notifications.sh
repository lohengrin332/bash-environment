#!/usr/bin/env bash


if [ -e /usr/local/bin/dunstctl ]; then
    /usr/local/bin/dunstctl set-paused false
else
    /usr/bin/notify-send "DUNST_COMMAND_RESUME"
fi

/usr/bin/notify-send "Resuming notifications"
