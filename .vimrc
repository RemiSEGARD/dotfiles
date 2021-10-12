" ~.vimrc

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" https://github.com/tpope/vim-sensible
Plugin 'tpope/vim-sensible'

" status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'ludovicchabant/vim-gutentags'

Plugin 'preservim/nerdtree'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

runtime! plugin/sensible.vim
set encoding=utf-8 fileencodings=
syntax on
set number
set cc=80
set scrolloff=5
"set list listchars=tab:»·,trail:
set noshowmode
set list
set listchars=tab:>─,eol:¬,trail:·,nbsp:¤
set tabstop=4 shiftwidth=4 expandtab
autocmd Filetype 'make' setlocal noexpandtab

set autoread
set autowrite

" mapping for quickfix list
nnoremap <leader>mm :silent! :make! \| :redraw!<cr>
nnoremap <leader>mo :cw<cr>
nnoremap <leader>mn :cnext<cr>

" buffer navigation
nnoremap <C-k> :bn<cr>
nnoremap <C-j> :bp<cr>
nnoremap <C-d>d :bn<BAR>bd#<cr>

" a few keybinds
"  like r but for inserting 1 char
nnoremap <C-I> i <ESC>r
nnoremap <C-A> a <ESC>r
"  swap current line below/above
nnoremap - ddp
nnoremap _ dd2kp
"  reindent everything in the current file
nnoremap <C-G> gg=<S-g><C-o>
"  uppercase current word
inoremap <C-u> <Esc>viwUea
nnoremap <C-u> viwUe
"  select current word
nnoremap <Space> viw

" highlighting trailing whitespace
hi GroupSpace ctermbg=red guibg=red
match GroupSpace / \+$/

" airline stuff
let g:airline_theme='simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Nerdtree
autocmd VimEnter * NERDTree | wincmd p
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" per .git vim configs
" just `git config vim.settings "expandtab sw=4 sts=4"` in a git repository
" change syntax settings for this repository
let git_settings = system("git config --get vim.settings")
if strlen(git_settings)
    exe "set" git_settings
endif
