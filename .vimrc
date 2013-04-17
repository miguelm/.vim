set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" My Bundles here :
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-rails'
Bundle 'Markdown'
" Bundle 'snipMate' 
Bundle 'UltiSnips'
" Bundle 'vim-powerline'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" Bundle 'ZenCoding.vim'
Bundle 'snipmate-snippets'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Syntastic'
Bundle 'airblade/vim-gitgutter'

" GLOBAL
colorscheme molokai
set guifont=Monaco\ for\ Powerline
"set guifont=Menlo+Regular+for+Powerline:h8:cDEFAULT

syntax on
filetype plugin indent on
set encoding=utf8
set hidden
set showcmd
" set nowrap
set autoindent
set ruler
set wildignore=*.swp,*.bak
set mouse=
set title
set visualbell
"set list

" Backups
set nobackup       " no backup files
set nowritebackup  " only in case you don't want a backup file while editing
set noswapfile     " no swap files

" Identation
set expandtab
set shiftwidth=2
set softtabstop=2

" Copy to clipboard
set guioptions+=a

" Removes the toolbar
set guioptions-=T

" Removes the menubar
set guioptions-=m

" Removes left and right scrollbars
set guioptions+=LlRrb
set guioptions-=LlRrb

" Coloca a linha em com o cursor em highlight nocul para tirar
set cul

" Option de ignore case nos searches / para remover set noic
set ic

" Option de highlight aos comandos quando se vai fazedno o search - fazer :help incsearch
set is

" Possibilidade de adicionar highlight a todas as pesquisas aquando feitas com set hls para ajudar ver :help hlsearch e remover :nohlsearch
set hls
" retirar o hls usando :noh

" Option de numeros nas linhas para retirar set nonumber
set number

" Teste de remap
" nnoremap <esc> :noh<return><esc>

" nnoremap y "+y
" vnoremap y "+y
"nnoremap p "+p
"vnoremap p "+p

" Function to Access Grep
function! MyGrep(...)
  if a:0 < 2
    echo "Usage: MyGrep <options> <pattern> <dir>"
    echo 'Example: MyGrep -r "cow" ~/Desktop/*'
    return
  endif
  if a:0 == 2
    let options = '-rsinI'
    let pattern = a:1
    let dir = a:2
  else
    let options = a:1 . 'snI'
    let pattern = a:2
    let dir = a:3
  endif
  let exclude = 'grep -v "/.git"'
  " Miguel added here only search in current dir
  " let cur_dir = './.dir.'
  " echo cur_dir
  let cmd = 'grep '.options.' '.pattern.' '.dir. '| '.exclude
  " echo cmd
  let cmd_output = system(cmd)
  if cmd_output == ""
    echomsg "Pattern " . pattern . " not found"
    return
  endif

  let tmpfile = tempname()
  exe "redir! > " . tmpfile
  silent echon '[grep search for "'.pattern.'" with options "'.options.'"]'."\n"
  silent echon cmd_output
  redir END

  let old_efm = &efm
  set efm=%f:%\\s%#%l:%m

  execute "silent! cgetfile " . tmpfile
  let &efm = old_efm
  botright copen

  call delete(tmpfile)
endfunction
command! -nargs=* -complete=file MyGrep call MyGrep(<f-args>)

""" FocusMode
function! ToggleFocusMode()
  if (&foldcolumn != 12)
    set laststatus=0
    set numberwidth=10
    set foldcolumn=12
    set noruler
    hi FoldColumn ctermbg=none
    hi LineNr ctermfg=0 ctermbg=none
    hi NonText ctermfg=0
  else
    set laststatus=2
    set numberwidth=4
    set foldcolumn=0
    set ruler
    execute 'colorscheme ' . g:colors_name
  endif
endfunc
nnoremap <F12> :call ToggleFocusMode()<cr>
