#!/usr/bin/env bash

# DEBUG_OUTPUT=1

do_log() {
    COUNT=$1
    shift
    MESSAGE="$1"
    shift
    if [ -z "${MESSAGE}" ]; then
        MESSAGE="n/a"
    fi

    if [ -n "$DEBUG_OUTPUT" ]; then
        echo "From _restart_notifications.sh: $(date '+%Y.%m.%d %H:%M:%S')-$1: ${MESSAGE}" >> /tmp/test_out.log
    fi
}

do_log 00 "(${DBUS_SESSION_BUS_ADDRESS}) (${LOGNAME})"
if [ -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
    export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gdm-x-session)/environ)
fi

do_log 10 "(${DBUS_SESSION_BUS_ADDRESS})"
notify-send 'Restarting notification daemon'

do_log 20 ""
sleep 5

do_log 30 ""
kill `pidof dunst`

do_log 40 ""
notify-send "Restarted notification daemon"

do_log 50 ""
