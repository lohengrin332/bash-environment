#!/bin/sh -v

    git subtree add --squash --prefix=.vim/bundle/vim-colors-solarized  https://github.com/altercation/vim-colors-solarized master 
    git subtree add --squash --prefix=.vim/bundle/vim-colors-vividchalk https://github.com/tpope/vim-vividchalk             master 
    git subtree add --squash --prefix=.vim/bundle/vim-distinguished     https://github.com/Lokaltog/vim-distinguished       master 
    git subtree add --squash --prefix=.vim/bundle/ack.vim               https://github.com/mileszs/ack.vim.git              master 
    git subtree add --squash --prefix=.vim/bundle/Align                 https://github.com/vim-scripts/Align.git            master 
    git subtree add --squash --prefix=.vim/bundle/perlmodop             https://github.com/lohengrin332/perlmodop.git       master 
    git subtree add --squash --prefix=.vim/bundle/taglist.vim           https://github.com/vim-scripts/taglist.vim.git      master 
    git subtree add --squash --prefix=.vim/bundle/vim-perl              https://github.com/vim-perl/vim-perl.git            master 
    git subtree add --squash --prefix=.vim/bundle/vim-matchit           https://github.com/edsono/vim-matchit.git           master 
    git subtree add --squash --prefix=.vim/bundle/mojo.vim              https://github.com/yko/mojo.vim.git                 master 