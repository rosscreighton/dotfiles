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
Plug 'Valloric/YouCompleteMe'
Plug 'xolox/vim-misc' " required by easytags
Plug 'xolox/vim-easytags' " auto generate tags file
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'vim-syntastic/syntastic'
Plug 'lepture/vim-jinja'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

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
let g:ctrlp_custom_ignore = '\.pyc'
let g:ctrlp_show_hidden = 1

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
let g:easytags_async = 1

" autopairs
let g:AutoPairsMapCh = 0

" NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

" Syntastic
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = './node_modules/.bin/eslint -f compat'


" vim-jsx
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" VIM SETTINGS
" -----------------------------------------------------------

syntax on
filetype plugin on
filetype indent on
filetype on
set number
set nowrap
set autoindent
set smartindent
set copyindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set preserveindent
set cursorcolumn
set cursorline
set incsearch
set backspace=indent,eol,start
set scrolloff=5
set sidescrolloff=5
set display+=lastline
set undofile
set undodir=~/.vim/undo
" remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e


" KEY MAPPINGS
" -----------------------------------------------------------

" next and previous buffers
nmap <C-h> :bp!<CR>
nmap <C-l> :bn!<CR>

let mapleader = "\<Space>"

nmap <leader>w :w<CR>
" save and close
nmap <leader>q :wq<CR>
" save and close current buffer
nmap <leader>c :w<CR>:bd<CR>
" close current buffer
nmap <leader>b :bd<CR>
" close all buffers
nmap <leader>ba :bufdo bd<CR>
" insert new line above cursor w/o entering insert mode
nmap <leader>ik O<Esc>j
" insert new line below cursor w/o entering insert mode
nmap <leader>ij o<Esc>k
" insert spaces around cursor
nmap <leader><Space> i<Space><Esc>la<Space><Esc>h
" open file with CtrlP
nmap <leader>o :CtrlPCurWD<CR>
" switch to buffer using CtrlP
nmap <leader>s :CtrlPBuffer<CR>
" switch to recently used file using CtrlP
nmap <leader>r :CtrlPMRU<CR>
" go to function def (tag) in current file
nmap <leader>g :CtrlPBufTagAll<CR>
" next entry in quickfix list
nmap <leader>n :cn<CR>
" previous entry in quickfix list
nmap <leader>p :cp<CR>
" search for next occurence of line under cursor
nmap <leader>nl :exec '/' . getline('.')<CR>
" easy window traveral
nmap <leader>j <C-w>j
nmap <leader>k <C-w>k
nmap <leader>h <C-w>h
nmap <leader>l <C-w>l
nmap <leader>x <C-w>q
" text traversal while in insert mode
imap <C-g> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
" toggle NERDTree
nmap <leader>\ :NERDTreeToggle<CR>
" toggle Tagbar
nmap <leader>/ :TagbarToggle<CR>
