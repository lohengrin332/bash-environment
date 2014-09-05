" Sets up reasonable defaults for using a tab-sensitive file, such as a Makefile
function TabSession()
    set tabstop=8
    set shiftwidth=8
    set softtabstop=8
    set noexpandtab
endfunction


" Finds perl modules on the line where the cursor currently is,
" loads them into the tagslist, and then opens the tagslist
function LoadSourceFile()
  if has("perl")
    if &filetype == "perl"
      :perl <<EOF
#EOF
        use strict;
        my $vim_utils = "$ENV{HOME}/.vim/lib";
        return unless(-e $vim_utils);
        unshift(@INC, $vim_utils);
        require VimTools;
        my $vt = VimTools->new(curwin => $main::curwin);
        $vt->loadSourceFile();
EOF
    endif
  endif
endfunction


" Finds perl modules on the line where the cursor currently is,
" and opens them in new tabs to the right of the current tab.
function OpenSourceFile()
  if has("perl")
    if &filetype == "perl"
      :perl <<EOF
#EOF
        use strict;
        my $vim_utils = "$ENV{HOME}/.vim/lib";
        return unless(-e $vim_utils);
        unshift(@INC, $vim_utils);
        require VimTools;
        my $vt = VimTools->new(curwin => $main::curwin);
        $vt->openSourceFile();
EOF
    endif
  endif
endfunction


" Shows the current @INC.
function ShowINC()
  if has("perl")
    :perl <<EOF
#EOF
      use strict;
      my $vim_utils = "$ENV{HOME}/.vim/lib";
      return unless(-e $vim_utils);
      unshift(@INC, $vim_utils);
      require VimTools;
      my $vt = VimTools->new(curwin => $main::curwin);
      my $str = join(', ', $vt->getINC());
      VIM::Msg($str);
EOF
  endif
endfunction


" Tests whether perl can be executed
function TestExec()
  if has("perl")
    :perl <<EOF
      use strict;
EOF
  endif
endfunction
