if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins installation
call plug#begin('~/.vim/plugged')

""""""""""""""""" langs
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'fatih/vim-go'
Plug 'raphael/vim-present-simple'
Plug 'rust-lang/rust.vim'


Plug 'tpope/vim-markdown'       	 	" Markup plugin
Plug 'Shougo/vimfiler.vim'                	" file explorer
Plug 'bronson/vim-trailing-whitespace'    	" :FixWhiteSpace
Plug 'Shougo/unite.vim'                   	" buffer
Plug 'Shougo/vimproc.vim'                 	" interactive command exec
Plug 'ryanoasis/vim-devicons'             	" utf8 icons
Plug 'itchyny/lightline.vim' 		    	" status line
Plug 'scrooloose/nerdtree' 		    	" tree
Plug 'scrooloose/nerdcommenter'             	" comment easy
Plug 'wincent/command-t' "needs rake make   	" file jumber
Plug 'terryma/vim-multiple-cursors'  	    	" Ctrl-n => default key
Plug 'ctrlpvim/ctrlp.vim'                 	" fuzzy search
Plug 'ervandew/supertab'

" git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-git'

""""""""""""" themes
Plug 'altercation/vim-colors-solarized'
Plug 'liuchengxu/space-vim-dark'

call plug#end()


" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <Leader>8 :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" https://blog.mikecordell.com/2015/01/27/better-fuzzy-search-with-ctrl-p-in-vim.html
if executable('matcher')
    let g:ctrlp_match_func = { 'match': 'GoodMatch' }

    function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

      " Create a cache file if not yet exists
      let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
      if !( filereadable(cachefile) && a:items == readfile(cachefile) )
        call writefile(a:items, cachefile)
      endif
      if !filereadable(cachefile)
        return []
      endif

      " a:mmode is currently ignored. In the future, we should probably do
      " something about that. the matcher behaves like "full-line".
      let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
      if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
        let cmd = cmd.'--no-dotfiles '
      endif
      let cmd = cmd.a:str

      return split(system(cmd), "\n")

    endfunction
end


filetype plugin indent on
let mapleader=","
"color solarized
"colorscheme space-vim-dark
color space-vim-dark
set cursorline " Highlight current line
set noswapfile
set encoding=utf8
"set guifont=DroidSansMono_Nerd_Font:h11


" Use space for :
noremap <space> :
map <leader>q :bd<Enter>

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
