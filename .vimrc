" commented lines start with `"'

" use pathogen
execute pathogen#infect()
execute pathogen#helptags()


" turn on mouse support
set mouse=a


" Indentation settings
" automatically indent lines (default)
set autoindent

" Sets default tabbing settings
function NoTabSession()
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal expandtab
endfunction
map gns :call NoTabSession()<CR>

" Sets default tabbing settings
function NoTabSession3()
    setlocal tabstop=3
    setlocal shiftwidth=3
    setlocal softtabstop=3
    setlocal expandtab
endfunction
map g3 :call NoTabSession3()<CR>

" Sets default tabbing settings
function NoTabSession2()
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal softtabstop=2
    setlocal expandtab
endfunction
map g2 :call NoTabSession2()<CR>

" Sets up reasonable defaults for using a tab-sensitive file, such as a Makefile
function TabSession()
    setlocal tabstop=8
    setlocal shiftwidth=8
    setlocal softtabstop=8
    setlocal noexpandtab
endfunction
map gs :call TabSession()<CR>

" set default tabstop, expandtab, etc
call NoTabSession()

" set .rb files to use two-space tabstops
autocmd BufNewFile,BufRead *.rb,*.yml :call NoTabSession2()

" Sets up a command to prettify the current json line
nmap gj :.!python -m json.tool<CR>
vmap gj :!python -m json.tool<CR>

" menu-style tab completion
set wildmenu

" Disable word-wrap
" set nowrap

" Search settings
" select case-insenitive search (not default)
set ignorecase

" turn on search highlighting
set hlsearch


" Color/Display settings
" show cursor line and column in the status line
set ruler

" set background to dark for syntax-higlighting purposes
if has('gui_running')
  set guioptions-=T  " no toolbar
  colorscheme darkblue
  set guifont=ProggyTinyTTSZ\ 12
else
  highlight Search ctermbg='Yellow' ctermfg='Black'
  set background=dark
  let term_app = $TERM_PROGRAM
  if term_app == 'iTerm.app'
    " echom "Setting mac colorscheme"
    if &diff
      " echom "Setting grb256 for diff"
      colorscheme grb256
    else
      " echom "Setting candy for editing"
      colorscheme candy
    endif
  else
    " echom "Setting grb256 for non-mac vim"
    colorscheme grb256
  endif
endif

" display mode INSERT/REPLACE/...
set showmode

" show matching brackets
set showmatch

" enable syntax highlighting
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding v
"    Enable folding, but by default make it act like folding is off, because folding is annoying in anything but a few rare cases
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable " Turn on folding
"set foldmethod=manual
"set foldmethod=indent " Make folding indent sensitive
"set foldlevel=100 " Don't autofold anything (but I can still fold manually)
"set foldopen-=search " don't open folds when you search into them
"set foldopen-=undo " don't open folds when you undo stuff
"set foldcolumn=3


" Open folds on:
"   - Horizontal movement upon the fold
"   - Movement to a mark
"   - Searches
"   - Movement to a tag
"   - Undo (or redo)
set foldopen=hor,mark,search,tag,undo
"set foldcolumn=6

"set foldmethod=syntax " Make folding syntax sensitive

"fold all POD comments, nothing else
set foldlevel=0
let perl_fold_pod=1
"let perl_fold_blocks=1
"let perl_fold=1
"let javaScript_fold=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding ^
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Tabbed editing
nnoremap <C-h>     :tabprevious<CR>
nnoremap <C-l>     :tabnext<CR>
set tabpagemax=50
" Ctrl_A e awaits a filename then edits that file in a new tab
" Ctrl_A c opens a new tab
" Ctrl_A n moves to the next tab in the list
" Ctrl_A p moves to the previous tab in the list
" Ctrl_A K close the current tab
" nmap <C-A>e :tabedit 
" nmap <C-A>c :tabnew<CR>
" nmap <C-A>n :tabnext<CR>
" nmap <C-A>p :tabprevious<CR>
" nmap <C-A>K :tabclose<CR>


filetype plugin on

" set .rpt, .sftp, .wfl, .dist, and .wfd files to use perl syntax
autocmd BufNewFile,BufRead *.rpt,*.sftp,*.cgi,*.wfl,*.dist,*.wfd,*.psgi   setf perl
autocmd BufNewFile,BufRead *.hbs    setf mustache


" Taglist settings
filetype on
let Tlist_Use_Horiz_Window = 0
let Tlist_Use_Right_Window = 1

" VimFunctions settings
map gt :call perlmodop#LoadPerlSourceFile()<CR>
map go :call perlmodop#OpenPerlSourceFile()<CR>
map gi :call perlmodop#ShowPerlINC()<CR>


" Terminal/other settings
" set number of history items to retain
set history=100

" changes special characters in search patterns (default)
" set magic

" Show line numbers
" set number

" Required to be able to use keypad keys and map missed escape sequences
set esckeys

" get easier to use and more user friendly vim defaults
" CAUTION: This option breaks some vi compatibility. 
"          Switch it off if you prefer real vi compatibility
set nocompatible

" Complete longest common string, then each full match
" enable this for bash compatible behaviour
" set wildmode=longest,full

" Ctrl_W e opens a vimshell in a horiz split window
" Ctrl_W E opens a vimshell in a vert split window
" nmap <C-W>e :new \| vimshell bash<CR>
" nmap <C-W>E :vnew \| vimshell bash<CR>

" Try to get the correct main terminal type
if &term =~ "xterm"
    let myterm = "xterm"
else
    let myterm =  &term
endif

if &term == "screen"
  set t_kb=
  fixdel
endif

let myterm = substitute(myterm, "screen",             "xterm", "")
let myterm = substitute(myterm, "cons[0-9][0-9].*$",  "linux", "")
let myterm = substitute(myterm, "vt1[0-9][0-9].*$",   "vt100", "")
let myterm = substitute(myterm, "vt2[0-9][0-9].*$",   "vt220", "")
let myterm = substitute(myterm, "\\([^-]*\\)[_-].*$", "\\1",   "")

" Here we define the keys of the NumLock in keyboard transmit mode of xterm
" which misses or hasn't activated Alt/NumLock Modifiers.  Often not defined
" within termcap/terminfo and we should map the character printed on the keys.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <F2>     /
    map! <F3>     *
    map! <F4>     -
    map! <ESC>Ol  +
    map! <ESC>OM  
    map! <ESC>Ow  7
    map! <ESC>Ox  8
    map! <ESC>Oy  9
    map! <ESC>Ot  4
    map! <ESC>Ou  5
    map! <ESC>Ov  6
    map! <ESC>Oq  1
    map! <ESC>Or  2
    map! <ESC>Os  3
    map! <ESC>Op  0
    map! <ESC>On  .
    " keys in normal mode
    map  <F2>     /
    map  <F3>     *
    map  <F4>     -
    map  <ESC>Ol  +
    map  <ESC>OM  
    map  <ESC>Ow  7
    map  <ESC>Ox  8
    map  <ESC>Oy  9
    map  <ESC>Ot  4
    map  <ESC>Ou  5
    map  <ESC>Ov  6
    map  <ESC>Oq  1
    map  <ESC>Or  2
    map  <ESC>Os  3
    map  <ESC>Op  0
    map  <ESC>On  .
endif

" xterm but without activated keyboard transmit mode
" and therefore not defined in termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>[H  <Home>
    map! <Esc>[F  <End>
    " Home/End: older xterms do not fit termcap/terminfo.
    map! <Esc>[1~ <Home>
    map! <Esc>[4~ <End>
    " Up/Down/Right/Left
    map! <Esc>[A  <Up>
    map! <Esc>[B  <Down>
    map! <Esc>[C  <Right>
    map! <Esc>[D  <Left>
    " KP_5 (NumLock off)
    map! <Esc>[E  <Insert>
    " PageUp/PageDown
    map <ESC>[5~ <PageUp>
    map <ESC>[6~ <PageDown>
    map <ESC>[5;2~ <PageUp>
    map <ESC>[6;2~ <PageDown>
    map <ESC>[5;5~ <PageUp>
    map <ESC>[6;5~ <PageDown>
    " keys in normal mode
    map <ESC>[H  0
    map <ESC>[F  $
    " Home/End: older xterms do not fit termcap/terminfo.
    map <ESC>[1~ 0
    map <ESC>[4~ $
    " Up/Down/Right/Left
    map <ESC>[A  k
    map <ESC>[B  j
    map <ESC>[C  l
    map <ESC>[D  h
    " KP_5 (NumLock off)
    map <ESC>[E  i
    " PageUp/PageDown
    map <ESC>[5~ 
    map <ESC>[6~ 
    map <ESC>[5;2~ 
    map <ESC>[6;2~ 
    map <ESC>[5;5~ 
    map <ESC>[6;5~ 
endif

" xterm/kvt but with activated keyboard transmit mode.
" Sometimes not or wrong defined within termcap/terminfo.
if myterm == "xterm" || myterm == "kvt" || myterm == "gnome"
    " keys in insert/command mode.
    map! <Esc>OH <Home>
    map! <Esc>OF <End>
    map! <ESC>O2H <Home>
    map! <ESC>O2F <End>
    map! <ESC>O5H <Home>
    map! <ESC>O5F <End>
    " Cursor keys which works mostly
    " map! <Esc>OA <Up>
    " map! <Esc>OB <Down>
    " map! <Esc>OC <Right>
    " map! <Esc>OD <Left>
    map! <Esc>[2;2~ <Insert>
    map! <Esc>[3;2~ <Delete>
    map! <Esc>[2;5~ <Insert>
    map! <Esc>[3;5~ <Delete>
    map! <Esc>O2A <PageUp>
    map! <Esc>O2B <PageDown>
    map! <Esc>O2C <S-Right>
    map! <Esc>O2D <S-Left>
    map! <Esc>O5A <PageUp>
    map! <Esc>O5B <PageDown>
    map! <Esc>O5C <S-Right>
    map! <Esc>O5D <S-Left>
    " KP_5 (NumLock off)
    map! <Esc>OE <Insert>
    " keys in normal mode
    map <ESC>OH  0
    map <ESC>OF  $
    map <ESC>O2H  0
    map <ESC>O2F  $
    map <ESC>O5H  0
    map <ESC>O5F  $
    " Cursor keys which works mostly
    " map <ESC>OA  k
    " map <ESC>OB  j
    " map <ESC>OD  h
    " map <ESC>OC  l
    map <Esc>[2;2~ i
    map <Esc>[3;2~ x
    map <Esc>[2;5~ i
    map <Esc>[3;5~ x
    map <ESC>O2A  ^B
    map <ESC>O2B  ^F
    map <ESC>O2D  b
    map <ESC>O2C  w
    map <ESC>O5A  ^B
    map <ESC>O5B  ^F
    map <ESC>O5D  b
    map <ESC>O5C  w
    " KP_5 (NumLock off)
    map <ESC>OE  i
endif

if myterm == "linux"
    " keys in insert/command mode.
    map! <Esc>[G  <Insert>
    " KP_5 (NumLock off)
    " keys in normal mode
    " KP_5 (NumLock off)
    map <ESC>[G  i
endif

" This escape sequence is the well known ANSI sequence for
" Remove Character Under The Cursor (RCUTC[tm])
map! <Esc>[3~ <Delete>
map  <ESC>[3~    x

" Only do this part when compiled with support for autocommands. 
if has("autocmd") 
  " When editing a file, always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside an event handler 
  " (happens when dropping a file on gvim). 
  autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" | 
    \ endif 
    " au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
 
endif " has("autocmd")

" Changed default required by SuSE security team
set modelines=5

" get easier to use and more user friendly vim defaults
" /etc/vimrc ends here
