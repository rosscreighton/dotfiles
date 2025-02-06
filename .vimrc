" Must do this first
" Allow vim to break compatibility with vi
set nocompatible


" VIM-PLUG CONFIGURATION AND PLUGINS
" -----------------------------------------------------------

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Specify plugins
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
Plug 'lepture/vim-jinja'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'junegunn/vim-easy-align'
Plug 'dense-analysis/ale'
Plug 'mechatroner/rainbow_csv'


" Initialize plugin system
call plug#end()


" CONFIGURE PLUGINS
" -----------------------------------------------------------

" Localvimrc
let g:localvimrc_name = '.localvimrc'
let g:localvimrc_persistent = 1

" Colorscheme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
set background=dark

" CtrlP
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_custom_ignore = '\.pyc\|node_modules\|DS_Store\|git'
let g:ctrlp_show_hidden = 1

" Airline
let g:airline_theme='gruvbox'
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

" Rainbow parentheses
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

augroup rainbow_parens
    autocmd!
    autocmd VimEnter * RainbowParentheses
augroup END

" Easytags
let g:easytags_async = 1

" Autopairs
let g:AutoPairsMapCh = 0

" NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

" ALE (Asynchronous Lint Engine)
let g:ale_linters = {'python': ['pyflakes']}
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['black'],
      \}


" vim-jsx
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" YouCompleteMe
"
" New mac installation settings:
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_global_extra_conf.py'
let g:ycm_add_preview_to_completeopt="popup"

" YCM settings from old mac:
"
" YCM requires python installation compiled with framework support.
" here's how to install that with pyenv:
" PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.6.4
" sometimes this command fails because zlib is unavailable. if so, try:
" sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
"let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'
"let g:ycm_path_to_python_interpreter = '/Users/rosscreighton/.pyenv/shims/python'
"let g:ycm_server_python_interpreter = '/Users/rosscreighton/.pyenv/shims/python'
"let g:ycm_server_python_interpreter = '~/.pyenv/versions/3.6.4'

"Prettier
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier


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


" KEY MAPPINGS
" -----------------------------------------------------------

" Next and previous buffers
nmap <C-h> :bp!<CR>
nmap <C-l> :bn!<CR>

let mapleader = "\<Space>"

nmap <leader>w :w<CR>
" Save and close
nmap <leader>q :wq<CR>
" Save and close current buffer
nmap <leader>c :w<CR>:bd<CR>
" Close current buffer
nmap <leader>b :bd<CR>
" Close all buffers
nmap <leader>ba :bufdo bd<CR>
" Insert new line above cursor w/o entering insert mode
nmap <leader>ik O<Esc>j
" Insert new line below cursor w/o entering insert mode
nmap <leader>ij o<Esc>k
" Insert spaces around cursor
nmap <leader><Space> i<Space><Esc>la<Space><Esc>h
" Open file with CtrlP
nmap <leader>o :CtrlPCurWD<CR>
" Switch to buffer using CtrlP
nmap <leader>s :CtrlPBuffer<CR>
" Switch to recently used file using CtrlP
nmap <leader>r :CtrlPMRU<CR>
" Go to function def (tag) in current file
nmap <leader>g :CtrlPBufTagAll<CR>
" Next entry in quickfix list
nmap <leader>n :cn<CR>
" Previous entry in quickfix list
nmap <leader>p :cp<CR>
" Search for next occurence of line under cursor
nmap <leader>nl :exec '/' . getline('.')<CR>
" Easy window traveral
nmap <leader>j <C-w>j
nmap <leader>k <C-w>k
nmap <leader>h <C-w>h
nmap <leader>l <C-w>l
nmap <leader>x <C-w>q
" Text traversal while in insert mode
imap <C-g> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
" Toggle NERDTree
nmap <leader>\ :NERDTreeToggle<CR>
" Toggle Tagbar
nmap <leader>/ :TagbarToggle<CR>
" Insert ipdb debugger
nmap <leader>d Oimport ipdb; ipdb.set_trace() :w<CR>
" Wrap each line in quotes and follow with comma. Intended use: prepare lines
" in a text file for copy and paste into a list of strings in a scripting
" language.
nmap <leader>] :%s/^/"/<CR>:%s/$/",/<CR>:w<CR>
