# .bashrc

# Setup:
# 1. Move proprietary commands from $HOME/.bashrc to $HOME/.bashrc_proprietary
# 2. Copy this file into $HOME, replacing the existing .bashrc.
# 3. Link rc files into $HOME:
#    cd $HOME ; ln -s $HOME/code/bash-env/{.bashrc_cross-system,.i3,.ideavimrc,.inputrc,.mongorc.js,.tmux.conf,.vim,.vimrc} .
#    mkdir -p $HOME/.config/Cursor/User ; ln -s $HOME/code/bash-env/cursor-keybindings.json $HOME/.config/Cursor/User/keybindings.json

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Source cross-system bashrc file
if [ -f "$HOME/.bashrc_cross-system" ]; then
  source $HOME/.bashrc_cross-system
fi

# Source machine-specific bashrc file
if [ -f "$HOME/.bashrc_proprietary" ]; then
  source $HOME/.bashrc_proprietary
fi
