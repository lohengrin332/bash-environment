# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login
# exists.
#
# Also, it is unnecessary if the server is configured to source your
# .bashrc file by default.
#
# if running bash
if [ -n "${BASH_VERSION}" ]; then
  if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
  fi
fi
