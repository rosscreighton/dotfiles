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
Plug 'yonchu/accelerated-smooth-scroll'

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
filetype plugin on
filetype indent on
filetype on
set number
set autoindent
set smartindent
set copyindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set preserveindent
" set cursorcolumn
set cursorline
set incsearch
set backspace=indent,eol,start
set scrolloff=10
set sidescrolloff=5
set display+=lastline
" remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e


" KEY BINDINGS
" -----------------------------------------------------------

let mapleader = "\<Space>"

nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
" save and close
nmap <leader>s :wq<CR>
" close current buffer
nmap <leader>x :bd<CR>
" insert new line above cursor w/o entering insert mode
nmap <leader>k O<Esc>j
" insert new line below cursor w/o entering insert mode
nmap <leader>j o<Esc>k
" insert spaces around cursor
nmap <leader><Space> i<Space><Esc>la<Space><Esc>h
" open file with CtrlP in mixed mode
nmap <leader>o :CtrlPCurWD<CR>
" jump to function def (tag) in current file
nmap <leader>g :CtrlPBufTagAll<CR>
