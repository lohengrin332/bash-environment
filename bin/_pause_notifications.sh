#!/usr/bin/env bash

DELAY=30
if [ "$#" != "0" ] && [ $1 -eq $1 2>/dev/null ]; then
    DELAY=$1
    shift
fi

TIMEFRAME='minutes'
if [ $DELAY -eq 1 ]; then
    TIMEFRAME='minute'
fi

if [ -z "$CODE_BASE" ]; then
    CODE_BASE=$(cat ~/.code_base_path)
fi

/usr/bin/notify-send 'Pausing Notifications' "Pausing notifications for ${DELAY} ${TIMEFRAME}"

${CODE_BASE}/bin/_disable_notifications.sh

at now + ${DELAY} ${TIMEFRAME} < ${CODE_BASE}/bin/_enable_notifications.sh
