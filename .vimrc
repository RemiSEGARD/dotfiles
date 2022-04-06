"---Plugins---
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-fugitive'
Plugin 'preservim/nerdtree' " might get rid of it at some point
Plugin 'ryanoasis/vim-devicons'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'ervandew/supertab'
"Plugin 'dense-analysis/ale'
Plugin 'justinmk/vim-syntax-extra'
Plugin 'TaDaa/vimade'
Plugin 'gosukiwi/vim-atom-dark'
Plugin 'rhysd/vim-clang-format'
Plugin 'jceb/vim-orgmode'
Plugin 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
call vundle#end()

" load vim-sensible before my settings
runtime! plugin/sensible.vim

"---Basic settings---
filetype plugin indent on
syntax on
set encoding=utf-8 fileencodings=
set number
set cc=80
set scrolloff=5
set noshowmode
set list
set listchars=tab:>─,eol:¬,trail:·,nbsp:¤
set tabstop=4 shiftwidth=4 expandtab
set wildmode=full
set wildmenu

autocmd Filetype 'make' setlocal noexpandtab
set autoread
set autowrite
set noswapfile

set pumheight=10
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

"---Theming---

"colorscheme
colorscheme atom-dark-256
"au Colorscheme * hi Normal guibg=NONE ctermbg=NONE
"au Colorscheme * hi EndOfBuffer guibg=NONE ctermbg=NONE

" cursorline
set cursorline
au Colorscheme * hi CursorLineNr cterm=NONE ctermbg=234 ctermfg=50
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" highlighting trailing whitespace
au Colorscheme * hi spaces ctermbg=red guibg=red
au Colorscheme * match spaces / \+$/

"---Mapping---

" mapping for quickfix list
nnoremap <leader>mm :silent! :make! \| :redraw!<cr>
nnoremap <leader>mo :cw<cr>
nnoremap <leader>mn :cnext<cr>

" buffer navigation
nnoremap <C-u> :bp<cr>
nnoremap <C-i> :bn<cr>
nnoremap <C-d>d :bn<BAR>bd#<cr>

" arrow mapping
nnoremap <Right> <Nop>
nnoremap <Left> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>

vnoremap <Right> <Nop>
vnoremap <Left> <Nop>
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-Right> <C-w>>
nnoremap <C-Left> <C-w><
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-

" navigate virtual lines
noremap j gj
noremap k gk

" swap current line below/above
nnoremap - :m .+1<cr>==
nnoremap _ :m .-2<cr>==

" select current word
nnoremap <Space> viw

" select current function
nnoremap <Leader><Space> [[v%

"---Plugin settings---

" airline stuff
let g:airline_theme='simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" powerline symbolds, disable if necessary
let g:airline_powerline_fonts = 1

" Nerdtree
autocmd VimEnter * NERDTree | wincmd p
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | wincmd h | execute 'cd '.argv()[0] | endif
noremap <Leader>t :NERDTreeToggle<CR>

" Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['.git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" Supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<C-n>"

" ClangFormat
let g:clang_format#auto_format = 1
autocmd FileType cpp ClangFormatAutoEnable

" Vimade (fading stuff)
let g:vimade = {}
let g:vimade.fadelevel = 0.5

" Tiger stuff
source ~/.vim/ftdetect/tiger.vim
autocmd FileType tiger source ~/.vim/syntax/tiger-syntax.vim
