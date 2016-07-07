set nocompatible
filetype off

"set rtp+=~/.vim/bundle/vundle/
" call vundle#rc()

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'Markdown'
Plugin 'UltiSnips'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'Syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'ervandew/supertab'
Plugin 'mattn/emmet-vim'
" Bundle 'tpope/vim-rails'
" Bundle 'snipMate'
" Bundle 'snipmate-snippets'
" Bundle 'vim-powerline'
" Bundle 'ZenCoding.vim'
" Bundle 'Valloric/YouCompleteMe'
" Bundle 'vim-easymotion'
call vundle#end()

" GLOBAL
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " osx stuff
    colorscheme solarized
    set guifont=Inconsolata\ for\ Powerline:h15
    let g:Powerline_symbols = 'fancy'
    set t_Co=256
    set fillchars+=stl:\ ,stlnc:\
    set term=xterm-256color
    set termencoding=utf-8
  else
    "arch stuff
    colorscheme molokai

    set guifont=Monaco\ for\ Powerline
    "set guifont=Menlo+Regular+for+Powerline:h8:cDEFAULT
  endif
endif

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

" UltiSnips
let g:UltiSnipsSnippetsDir = '~/.vim/snippers/'
let g:UltiSnipsSnippetDirectories = ['snippers','snippers/legacy/']

" Emmet
let g:user_emmet_leader_key='<Tab>'

" Teste de remap
" nnoremap <esc> :noh<return><esc>

map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " osx stuff
    map <c-s> <c-x><CR>

    set backspace=indent,eol,start

    if &term =~ "xterm.*"
        let &t_ti = &t_ti . "\e[?2004h"
        let &t_te = "\e[?2004l" . &t_te
        function XTermPasteBegin(ret)
            set pastetoggle=<Esc>[201~
            set paste
            return a:ret
        endfunction
        map <expr> <Esc>[200~ XTermPasteBegin("i")
        imap <expr> <Esc>[200~ XTermPasteBegin("")
        cmap <Esc>[200~ <nop>
        cmap <Esc>[201~ <nop>
    endif

  endif
endif

" Function to Access Grep
function! Mgrep(...)
  if a:0 < 2
    echo "Usage: Mgrep <options> <pattern> <dir>"
    echo 'Example: Mgrep -r "cow" ~/Desktop/*'
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
command! -nargs=* -complete=file Mgrep call Mgrep(<f-args>)

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

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
