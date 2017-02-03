" must do this first
" allow vim to break compatibility with vi
set nocompatible


" VIM-PLUG CONFIGURATION AND PLUGINS  
" -----------------------------------------------------------

" specify a directory for plugins
call plug#begin('~/.vim/plugged')

" specify plugins
Plug 'morhetz/gruvbox'

" initialize plugin system
call plug#end()


" CONFIGURE PLUGINS
" -----------------------------------------------------------

let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
set background=dark


"  VIM SETTINGS 
" -----------------------------------------------------------

syntax on
set number
