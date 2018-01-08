if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Go plugins
Plug 'fatih/vim-go'
Plug 'raphael/vim-present-simple'
" Scala
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }

" Markup plugins
Plug 'tpope/vim-markdown'
 


Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'wincent/command-t' "needs rake make
Plug 'terryma/vim-multiple-cursors'  " Ctrl-n => default key
Plug 'ervandew/supertab'

" Git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-git'

Plug 'altercation/vim-colors-solarized'

" Initialize plugin system
call plug#end()

filetype plugin indent on
let mapleader=","
color solarized
set noswapfile

" Use space for :
noremap <space> :

" Quick ESC
imap jj <ESC>

" Stupid backspace fix
set backspace=indent,eol,start

" Enable line nums
set number

" cursors crap
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"set signcolumn=yes

" Lightline settings
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
set noshowmode "Disable status

" Strip trailing space for a list of extensions
autocmd BufWritePre *.builder,*.c,*.coffee,*.elm,*.ex,*.exs,*.haml,*.html,*.js,*.lua,*.markdown,*.md,*.rb,*.rs,*.scss,*.txt :call <SID>StripTrailingSpace()

" Set noeol on all new files
autocmd BufNewFile * set noeol


" NerD Tree
nmap <leader>j :NERDTreeFind<CR>
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeMapActivateNode='<right>'
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg', 'reports', 'Godeps', '_workspace', 'gin-bin', 'deps', '_build', 'vendor']


" CommandT
set wildignore+=*.log,*.sql,*.cache,.git,target
"nmap <silent> <Leader>t <Plug>(CommandT)
"nmap <silent> <Leader>b <Plug>(CommandTBuffer)
"nmap <silent> <Leader>j <Plug>(CommandTJump)



" Nerd Commenter
filetype plugin on
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1



syntax on
filetype plugin indent on

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

set guifont=Droid\ Sans\ Mono\ for\ Powerline:h11
