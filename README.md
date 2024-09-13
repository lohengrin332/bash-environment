# Setup for Ubuntu/i3:
1. Move proprietary commands from `$HOME/.bashrc` to `$HOME/.bashrc_proprietary`
2. Copy this file into `$HOME`, replacing the existing `.bashrc`.
3. Link rc files into `$HOME`:
   `cd $HOME ; ln -s $HOME/code/bash-env/{.bashrc_cross-system,.i3,.ideavimrc,.inputrc,.mongorc.js,.tmux.conf,.vim,.vimrc} .`
4. Follow instructions for [libinput](https://wiki.archlinux.org/title/Libinput#Via_xinput_on_Xorg) to enable "Tapping Enabled" for the touchpad device.
   *Note*: `xinput` is likely already installed, so try that before trying to install libinput or other tools.
5. Install desired prereqs as specified in [the i3 config file](.i3/config).
