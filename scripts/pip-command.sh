#!/bin/sh

PIP_SESSION_NAME='pip'

echo '#!/bin/sh' > /tmp/script_for_pip.sh
echo $@ >> /tmp/script_for_pip.sh
chmod 700 /tmp/script_for_pip.sh

tmux new -d -s $PIP_SESSION_NAME '/tmp/script_for_pip.sh ; read'
PIP_SESSION_NAME=$PIP_SESSION_NAME xterm -fn '-windows-proggytinysz-medium-r-normal--10-80-96-96-c-60-iso8859-1' -e ~/code/bash-env/scripts/i3pip-console.sh &
