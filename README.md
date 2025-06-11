# Setup for Ubuntu/i3:
1. Move proprietary commands from `$HOME/.bashrc` to `$HOME/.bashrc_proprietary`.
2. Copy this file into `$HOME`, replacing the existing `.bashrc`.
3. Link rc files into `$HOME`:
   ```shell
   cd $HOME
   ln -s $HOME/code/bash-env/{.bashrc_cross-system,.i3,.ideavimrc,.inputrc,.mongorc.js,.tmux.conf,.vim,.vimrc} .
   mkdir -p $HOME/.config/Cursor/User
   ln -s $HOME/code/bash-env/cursor-keybindings.json $HOME/.config/Cursor/User/keybindings.json
   ```
5. Follow instructions to enable "Tapping Enabled" for the touchpad device
   in [libinput](https://wiki.archlinux.org/title/Libinput#Via_Xorg_configuration_file).

   Follow the instructions to configure via Xorg configuration file. XOrg logs are likely in `$HOME/.local/share/xorg/Xorg.0.log`.
   
   *Note*: If needed `xinput` is likely already installed and configured, so try that before trying to install libinput or other tools.
6. Install desired prereqs as specified in [the i3 config file](.i3/config#L201-L217).
