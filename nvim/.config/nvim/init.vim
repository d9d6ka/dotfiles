if (has('win32') || has('win64'))
    if empty(glob('~/AppData/Local/nvim/autoload/plug.vim'))
        silent ! powershell -Command "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"$env:LOCALAPPDATA/nvim/autoload/plug.vim\" -Force"
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    let g:python3_host_prog="C:/Users/vadim/scoop/apps/python/current/python.exe"
endif

if has('unix')
    if &shell =~# 'fish$'
        set shell=sh
    endif
    if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
        silent ! curl -fLo "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

silent! call plug#begin()
    " UI related
    Plug 'itchyny/lightline.vim'
    Plug 'arcticicestudio/nord-vim'
    Plug 'lambdalisue/fern.vim'
    Plug 'antoinemadec/FixCursorHold.nvim'
    if has('unix')
        Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
    endif        

    " Editing
    Plug 'terryma/vim-multiple-cursors'
    Plug 'haya14busa/incsearch.vim'
    Plug 'unblevable/quick-scope'
    
    " Markdown
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    
    " Formater
    Plug 'Chiel92/vim-autoformat'
    Plug 'tell-k/vim-autopep8'
    
    " Syntax check
    Plug 'dense-analysis/ale'
    
    " CoC
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Git
    Plug 'tpope/vim-fugitive'
call plug#end()

" CoC
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" UI configuration
syntax on
syntax enable
set number
set relativenumber
set termguicolors

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
autocmd ColorScheme * highlight Visual cterm=reverse
colorscheme nord

" cursorline and cursorcolumn
au WinLeave * set nocursorline nocursorcolumn
au BufEnter,WinEnter * set cursorline cursorcolumn

" hexokinase
if has('unix')
    let g:Hexokinase_highlighters = ['backgroundfull']
    let g:Hexokinase_refreshEvents = ['InsertLeave']
    let g:Hexokinase_optInPatterns = [
    \     'full_hex',
    \     'triple_hex',
    \     'rgb',
    \     'rgba',
    \     'hsl',
    \     'hsla',
    \     'colour_names'
    \ ]
    autocmd VimEnter * HexokinaseTurnOn
endif

" Tab and Indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set expandtab

" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8']}

" VimMarkdown
let g:vim_markdown_folding_disabled = 1

" IncSearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_lazy_highlight = 1

" Custom keys
nmap <silent> <esc><esc> :nohls<cr> :let @/=""<cr>
