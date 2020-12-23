" --- Install Vim-plug in Windows ---
if (has('win32') || has('win64'))
    if empty(glob('~/AppData/Local/nvim/autoload/plug.vim'))
        silent ! powershell -Command "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"$env:LOCALAPPDATA/nvim/autoload/plug.vim\" -Force"
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    let g:python3_host_prog="C:/Users/vadim/scoop/apps/python/current/python.exe"
endif

" --- Install Vim-plug manager in *nix-like systems ---
if has('unix')
    if &shell =~# 'fish$'
        set shell=sh
    endif
    if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
        silent ! curl -fLo "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" === Install plugins ===
silent! call plug#begin()
    " Color scheme
    Plug 'arcticicestudio/nord-vim'
    Plug 'chriskempson/base16-vim'

    " UI related
    Plug 'itchyny/lightline.vim'
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

    " Fish
    Plug 'dag/vim-fish'

    " Git
    Plug 'tpope/vim-fugitive'

    " Vimwiki
    Plug 'vimwiki/vimwiki'
call plug#end()

" === Vim settings ===
" --- color scheme ---
autocmd ColorScheme * highlight Visual cterm=reverse
colorscheme base16-zenburn

" --- unix/windows ---
set ssl

" --- UI configuration ---
filetype plugin on
syntax on
set number
set relativenumber
set termguicolors

" --- tab and indent ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set expandtab

" --- cursorline and cursorcolumn ---
au WinLeave * set nocursorline nocursorcolumn
au BufEnter,WinEnter * set cursorline cursorcolumn

" --- Custom keys ---
nmap <silent> <esc><esc> :nohls<cr> :let @/=""<cr>

" === Third-party plugins ===
" --- Lightline ---
let g:lightline = {
      \ 'colorscheme' : 'zenburn',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" --- Hexokinase ---
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

" --- CoC ---
let g:coc_global_extensions = ['coc-pyright']

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

" --- Ale ---
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8']}

" --- VimMarkdown ---
let g:vim_markdown_folding_disabled = 1

" --- IncSearch ---
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" --- Quick-scope ---
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_lazy_highlight = 1

" --- Vimwiki ---
let wiki1 = {}
let wiki1.auto_export = 1
let wiki1.automatic_nested_syntaxes = 1
let wiki1.syntax = 'markdown'
let wiki1.ext = '.md'
let wiki1.links_space_char = "_"
let wiki1.custom_wiki2html = 'vimwiki_markdown'
if has('unix')
    let wiki1.path = '~/Документы/vimwiki/wiki'
    let wiki1.path_html = '~/Документы/vimwiki/html'
    let wiki1.template_path = '~/Документы/vimwiki'
endif
if (has('win32') || has('win64'))
    let wiki1.path = 'D:/git/vimwiki/wiki'
    let wiki1.path_html = 'D:/git/vimwiki/html'
    let wiki1.template_path = 'D:/git/vimwiki'
endif
let g:vimwiki_list = [wiki1]
let g:vimwiki_global_ext = 0
let g:vimwiki_markdown_link_ext = 1
