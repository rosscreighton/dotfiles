" must do this first
" allow vim to break compatibility with vi
set nocompatible


" VIM-PLUG CONFIGURATION AND PLUGINS
" -----------------------------------------------------------

" specify a directory for plugins
call plug#begin('~/.vim/plugged')

" specify plugins
Plug 'morhetz/gruvbox'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'vim-airline/vim-airline'
Plug 'junegunn/rainbow_parentheses.vim'
" automatically start ins-completion so we don't have to press <c-x>
Plug 'vim-scripts/AutoComplPop' 
Plug 'xolox/vim-misc' " required by easytags
Plug 'xolox/vim-easytags' " auto generate tags file

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
set laststatus=2

" rainbow parentheses
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

augroup rainbow_parens
  autocmd!
  autocmd VimEnter * RainbowParentheses
augroup END

" easytags
let g:easytags_always_enabled = 1

 
" VIM SETTINGS
" -----------------------------------------------------------

syntax on
set number


" KEY BINDINGS
" -----------------------------------------------------------

let mapleader = "\<Space>"

nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
" save and close
nmap <leader>s :wq<CR>
" insert new line above cursor w/o entering insert mode
nmap <leader>k O<Esc>j
" insert new line below cursor w/o entering insert mode
nmap <leader>j o<Esc>k
" open file with CtrlP in mixed mode
nmap <leader>o :CtrlPMixed<CR>
" jump to function def (tag) in current file
nmap <leader>g :CtrlPTag<CR>
