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

" theme
Plugin 'tomasiser/vim-code-dark'
Plugin 'zacanger/angr.vim'

" tag management
Plugin 'ludovicchabant/vim-gutentags'

" file explorer
Plugin 'preservim/nerdtree'

" fades inactive windows
Plugin 'TaDaa/vimade'

" syntax checker
Plugin 'vim-syntastic/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

"colorscheme codedark

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
"autocmd Filetype 'make' setlocal noexpandtab
set noswapfile

set autoread
set autowrite
set cursorline
hi CursorLine   cterm=NONE ctermbg=234 ctermfg=NONE
hi CursorLineNr cterm=NONE ctermbg=234 ctermfg=50
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" mapping for quickfix list
nnoremap <leader>mm :silent! :make! \| :redraw!<cr>
nnoremap <leader>mo :cw<cr>
nnoremap <leader>mn :cnext<cr>

" buffer navigation
nnoremap <C-k> :bn<cr>
nnoremap <C-j> :bp<cr>
nnoremap <C-d>d :bn<BAR>bd#<cr>

" window resize
noremap <F5> :res -1<cr>
noremap <F6> :res +1<cr>

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
"  select current function
nnoremap <Leader><Space> [[v%

" highlighting trailing whitespace
hi GroupSpace ctermbg=red guibg=red
match GroupSpace / \+$/

" make function calls bold
hi Function cterm=bold

" airline stuff
let g:airline_theme='simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Nerdtree
autocmd VimEnter * NERDTree | wincmd p
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | wincmd h | execute 'cd '.argv()[0] | endif
noremap <Leader>t :NERDTreeToggle<CR>

" Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" Vimade (fading stuff)
let g:vimade = {}
let g:vimade.fadelevel = 0.5

"syntastic stuff
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" per .git vim configs
" just `git config vim.settings "expandtab sw=4 sts=4"` in a git repository
" change syntax settings for this repository
let git_settings = system("git config --get vim.settings")
if strlen(git_settings)
    exe "set" git_settings
endif

