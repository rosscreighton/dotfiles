" must do this first
" allow vim to break compatibility with vi
set nocompatible


"  VIM-PLUG CONFIGURATION AND PLUGINS  
" -----------------------------------------------------------

" specify a directory for plugins
call plug#begin('~/.vim/plugged')

" specify plugins
Plug 'flazz/vim-colorschemes'

" initialize plugin system
call plug#end()


" CONFIGURE PLUGINS
" -----------------------------------------------------------

colorscheme gruvbox
set background=dark

"  VIM SETTINGS 
" -----------------------------------------------------------

syntax on
