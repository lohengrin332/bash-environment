#!/bin/sh
if [ -z "$PIP_SESSION_NAME" ]; then
    PIP_SESSION_NAME=pip
fi
export PIP_WIDTH=500
export PIP_HEIGHT=250
export PIP_INSET=10
export PIP_OVERLAY=282 # Minimum width of a terminal, found using `xprop | grep minimum`

TOTAL_WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | sed 's/x[0-9]\+$//')
RIGHT_MAX=$(expr $TOTAL_WIDTH - $PIP_WIDTH - $PIP_OVERLAY)
RIGHT_INSET=$(expr $RIGHT_MAX - $PIP_INSET)

if [ -z "$(tmux ls 2> /dev/null|grep $PIP_SESSION_NAME)" ]; then
    tmux new -d -s $PIP_SESSION_NAME
fi

/usr/bin/i3-msg "mark $PIP_SESSION_NAME; floating toggle; sticky toggle; resize shrink width 10000px; resize grow width ${PIP_WIDTH}px; resize shrink height 10000px; resize grow height ${PIP_HEIGHT}px; move position ${RIGHT_INSET}px ${PIP_INSET}px"
# ~/code/bash-env/scripts/i3pip-relocate.sh right
# ~/code/bash-env/scripts/i3pip-relocate.sh top
tmux a -t $PIP_SESSION_NAME
