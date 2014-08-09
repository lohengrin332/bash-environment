# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f "$HOME/.bash_proprietary" ]; then
  source $HOME/.bash_proprietary
fi

if [ ! -d "$CODE_BASE" ]; then
  export CODE_BASE=$HOME/code/bash-env
fi

export INPUTRC="$CODE_BASE/.inputrc"

if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

if [ -f $CODE_BASE/git ]; then
  . $CODE_BASE/git
fi

# User specific aliases and functions

# Commented out in favor of using "set editing-mode vi" in .inputrc
#set -o vi

alias _dbic_trace='dbic_trace_on'
dbic_trace_on() {
    export DBIC_TRACE=1
    export DBIC_TRACE_PROFILE=console
}
alias _no_dbic_trace='dbic_trace_off'
dbic_trace_off() {
    unset DBIC_TRACE
    unset DBIC_TRACE_PROFILE
}

alias cd='cd_func'
cd_func() {
  if [ -z "$*" ]; then
    pushd $HOME > /dev/null
  elif [ $1 == '-' ]; then
    popd > /dev/null
  else
    pushd "$*" > /dev/null
  fi
}
alias bd='bd_func'
bd_func() { popd $* > /dev/null; }

if [ `which ack 2>/dev/null` ]; then
    alias sgrep='echo "WTF?!? Use \"ack\"!!!" #'
    alias psgrep='echo "WTF?!? Use \"ack --perl\"!!! (or "ack_perl")" #'
    alias jsgrep='echo "WTF?!? Use \"ack --js --json --html\"!!! (or "ack_js")" #'
    alias rsgrep='echo "WTF?!? Use \"ack --js --json --html\"!!! (or "ack_ruby")" #'
    alias ack_perl='ack --perl'
    alias ack_js='ack --js --json --html --tt'
    alias ack_ruby='ack --ruby'
else
    alias sgrep='find ./ -type f -not -wholename \*svn\* -not -wholename \*git\*|sed "s/\(\s\)/\\\\\1/g"|xargs grep'
    alias psgrep='find ./ -type f "(" -iname \*.pl -or -iname \*.pm -or -iname \*.cgi ")" -not -wholename \*svn\* -not -wholename \*git\*|sed "s/\(\s\)/\\\\\1/g"|xargs grep'
    alias jsgrep='find ./ -type f "(" -iname \*.html -or -iname \*.js -or -iname \*.json ")" -not -wholename \*svn\* -not -wholename \*git\*|sed "s/\(\s\)/\\\\\1/g"|xargs grep'
fi

alias xml='vim_xml'
vim_xml() {
  xmllint --format "$1" | vim -R -
}

alias myscreen='screen_func'
screen_func() {
  if [ -z "$(screen -ls|grep main)" ]; then
    cat $CODE_BASE/.screenrc > /tmp/$$_screenrc.tmp
    cat $CODE_BASE/.screenrc_sessions >> /tmp/$$_screenrc.tmp
    screen -c /tmp/$$_screenrc.tmp -S main
  else
    screen -xS main
  fi
}

if [ -e /usr/bin/vim ]; then
  export EDITOR='/usr/bin/vim'
  export VISUAL='/usr/bin/vim'
else
  export EDITOR='/bin/vi'
  export VISUAL='/bin/vi'
fi

if [ -e $CODE_BASE/.bash_prompt ]; then
  . $CODE_BASE/.bash_prompt
else
  #export PS1="[\u@\h \W]\$ "
  if [ $HOSTNAME == 'ln5dev-mbx-d-1.mindbrix.com' ] || [ $HOSTNAME == 'ln5test-mbx-d-1.mindbrix.com' ] ; then
    export PS1='\[\e[31m\]\u@\h\[\e[33m\]:\w\[\e[0m\]\n\$ \[\033]0;\h:\W\007\]'
  else
    export PS1='\[\e[32m\]\u@\h\[\e[33m\]:\w\[\e[0m\]\n\$ \[\033]0;\h:\W\007\]'
  fi
fi

if [ -e $HOME/bin/charade.exe ]; then
  SSHAGENT=$HOME/bin/charade
  SSHAGENTARGS='-s'
  if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
    alias ssh='/usr/bin/ssh -A'
  fi
elif [ -e $CODE_BASE/bin/ssh-agentrc ]; then
  source $CODE_BASE/bin/ssh-agentrc
else
  alias ssh='ssh -A'
fi
#alias ssh='ssh_func'
#ssh_func() {
#  export SSH_AUTH_SOCK=`$HOME/code/get_ssh_sock.pl`
#  /usr/bin/ssh -A $*
#}

alias svndiff=$CODE_BASE/bin/svndiff.pl
alias gitdiff='git difftool'

export NYTPROF="file=$HOME/nytprof/nytprof.out:addpid=1"

export PATH="$PATH:$HOME/bin"
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='0;07'

dircolors_exe=/usr/bin/dircolors
if [ ! -x "$dircolors_exe" ]; then
    if [ -x /usr/local/bin/gdircolors ]; then
        dircolors_exe=/usr/local/bin/gdircolors
    fi
fi
if [ -e $CODE_BASE/dircolors.256dark ] && [ -x "$dircolors_exe" ]; then
    ${dircolors_exe} $CODE_BASE/dircolors.256dark > /var/tmp/$USER.dircolors.bash
    source /var/tmp/$USER.dircolors.bash
else
    export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:";
fi

if [ -x /usr/local/bin/gls ]; then
    alias ls='/usr/local/bin/gls --color=auto'
fi

if [ -x /opt/local/bin/gfind ]; then
    alias find='/opt/local/bin/gfind'
fi

