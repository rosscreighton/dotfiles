" must do this first
" allow vim to break compatibility with vi
set nocompatible


" VIM-PLUG CONFIGURATION AND PLUGINS
" -----------------------------------------------------------

" specify a directory for plugins
call plug#begin('~/.vim/plugged')

" specify plugins
Plug 'embear/vim-localvimrc'
Plug 'morhetz/gruvbox'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'vim-airline/vim-airline'
Plug 'junegunn/rainbow_parentheses.vim'
" automatically start ins-completion so we don't have to press <c-x>
Plug 'vim-scripts/AutoComplPop'
Plug 'xolox/vim-misc' " required by easytags
Plug 'xolox/vim-easytags' " auto generate tags file
Plug 'yonchu/accelerated-smooth-scroll'
Plug 'lepture/vim-jinja'
Plug 'scrooloose/nerdtree'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'

" initialize plugin system
call plug#end()


" CONFIGURE PLUGINS
" -----------------------------------------------------------

" localvimrc
let g:localvimrc_name = '.localvimrc'
let g:localvimrc_persistent = 1

" colorscheme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
set background=dark

" CtrlP
let g:ctrlp_open_new_file = 'r'

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
let g:easytags_async = 1

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
set cursorcolumn
set cursorline
set incsearch
set backspace=indent,eol,start
set scrolloff=5
set sidescrolloff=5
set display+=lastline
" remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e


" KEY MAPPINGS
" -----------------------------------------------------------

" next and previous buffers
nmap <C-h> :bp<CR>
nmap <C-l> :bn<CR>

let mapleader = "\<Space>"

nmap <leader>w :w<CR>
" save and close
nmap <leader>q :wq<CR>
" save and close current buffer
nmap <leader>c :w<CR>:bd<CR>
" insert new line above cursor w/o entering insert mode
nmap <leader>k O<Esc>j
" insert new line below cursor w/o entering insert mode
nmap <leader>j o<Esc>k
" insert spaces around cursor
nmap <leader><Space> i<Space><Esc>la<Space><Esc>h
" open file with CtrlP
nmap <leader>o :CtrlPCurWD<CR>
" switch to buffer using CtrlP
nmap <leader>s :CtrlPBuffer<CR>
" next entry in quickfix list
nmap <leader>n :cn<CR>
" previous entry in quickfix list
nmap <leader>p :cp<CR>
" switch to recently used file using CtrlP
nmap <leader>r :CtrlPMRU<CR>
" jump to function def (tag) in current file
nmap <leader>g :CtrlPBufTagAll<CR>
" search for next occurence of line under cursor
nmap <leader>nl :exec '/' . getline('.')<CR>
" easy window traveral
nmap <leader>j <C-w>j
nmap <leader>k <C-w>k
nmap <leader>h <C-w>h
nmap <leader>l <C-w>l
nmap <leader>x <C-w>q
" toggle NERDTree
nmap <leader>\ :NERDTreeToggle<CR>
