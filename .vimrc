" must do this first
" allow vim to break compatibility with vi
set nocompatible


" VIM-PLUG CONFIGURATION AND PLUGINS  
" -----------------------------------------------------------

" specify a directory for plugins
call plug#begin('~/.vim/plugged')

" specify plugins
Plug 'morhetz/gruvbox'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'

" initialize plugin system
call plug#end()


" CONFIGURE PLUGINS
" -----------------------------------------------------------

" colorscheme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
set background=dark

" airline
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1


"  VIM SETTINGS 
" -----------------------------------------------------------

syntax on
set number


"  VIM SETTINGS 
" -----------------------------------------------------------

nmap <C-K> O<Esc>j
nmap <C-J> o<Esc>k
