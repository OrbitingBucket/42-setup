" 42 École Vim Configuration
" Optimized for École 42 projects and norminette compliance
" Enhanced with NvChad-like features for modern development

" ============================================================================
" Plugin Manager (vim-plug)
" ============================================================================

" Auto-install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Look & feel
Plug 'sheerun/vim-polyglot'                    " Syntax for 200+ languages
Plug 'catppuccin/vim', { 'as': 'catppuccin' } " Catppuccin theme
Plug 'itchyny/lightline.vim'                   " Status line
Plug 'bling/vim-bufferline'                    " Buffer tabs
Plug 'ryanoasis/vim-devicons'                  " File icons (needs Nerd Font)

" File explorer
Plug 'preservim/nerdtree'                      " File tree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Syntax colors in NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'            " Git status in NERDTree

" Terminal integration
Plug 'kassio/neoterm'                          " Enhanced terminal

" Editing enhancements
Plug 'jiangmiao/auto-pairs'                    " Auto-close brackets/quotes
Plug 'tpope/vim-surround'                      " Surround text with quotes/brackets
Plug 'preservim/nerdcommenter'                 " Smart commenting
Plug 'luochen1990/rainbow'                     " Rainbow parentheses

" Optional: Fuzzy finder (needs fzf binary)
" Plug 'junegunn/fzf.vim'

call plug#end()

" ============================================================================
" Basic Settings
" ============================================================================

" Enable syntax highlighting
syntax enable
syntax on

" Enable file type detection and plugins
filetype on
filetype plugin on
filetype indent on

" Line numbers
set number

" Indentation and tabs (42 norm: 4 spaces, no tabs)
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set smartindent
set autoindent

" Search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" Interface
set mouse=a
set showmatch
set ruler
set showcmd
set laststatus=2

" Editing behavior
set backspace=indent,eol,start
set wrap
set linebreak
set scrolloff=8
set sidescrolloff=8

" 24-bit color support (for themes)
if has('termguicolors')
  set termguicolors
endif

" ============================================================================
" Catppuccin Theme Configuration (Official Plugin)
" ============================================================================

" Enable true color support
set termguicolors

" Set background before loading colorscheme
set background=dark

" Apply Catppuccin Mocha colorscheme (after plugins are loaded)
augroup LoadColorScheme
    autocmd!
    autocmd VimEnter * ++nested colorscheme catppuccin_mocha
augroup END

" ============================================================================
" Plugin Configurations
" ============================================================================

" Lightline (status bar) - will be configured after colorscheme loads
augroup LightlineConfig
    autocmd!
    autocmd VimEnter * ++nested call SetupLightline()
augroup END

function! SetupLightline()
    let g:lightline = {
          \ 'colorscheme': 'catppuccin_mocha',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'readonly', 'filename', 'modified' ] ]
          \ },
          \ }
endfunction

" NERDTree
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore = ['\.DS_Store$', '\.git$']
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1
let g:NERDTreeShowLineNumbers=0
let g:NERDTreeWinSize=30

" Auto-close NERDTree if it's the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Auto-open NERDTree on directory open
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Rainbow parentheses (using Catppuccin colors)
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['#f38ba8', '#fab387', '#f9e2af', '#a6e3a1', '#94e2d5', '#89b4fa', '#cba6f7', '#f5c2e7'],
\	'ctermfgs': ['red', 'yellow', 'green', 'cyan', 'blue', 'magenta', 'red', 'yellow'],
\}

" Auto-pairs
let g:AutoPairsShortcutToggle = '<M-p>'
let g:AutoPairsShortcutFastWrap = '<M-e>'

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" Neoterm
let g:neoterm_default_mod='botright'
let g:neoterm_size=10
let g:neoterm_autoscroll=1
let g:neoterm_keep_term_open=1

" File handling
set autoread
set noswapfile
set nobackup
set nowritebackup

" Better completion
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noselect

" ============================================================================
" 42 Specific Settings
" ============================================================================

" Highlight line length limit (42 norm: 80 characters)
highlight ColorColumn ctermbg=red guibg=#ff6b6b
call matchadd('ColorColumn', '\%81v', 100)

" Clean interface - no visible whitespace chars
" set list
" set listchars=tab:→\ ,trail:•,nbsp:␣

" ============================================================================
" Key Mappings
" ============================================================================

" Leader key
let mapleader = " "

" CMD enter command mode (semicolon to colon)
nnoremap ; :

" Quick escape from insert mode
inoremap jk <ESC>

" Quick save with capital W
nnoremap W :w<CR>

" Your custom bindings
" Insert mode: Alt-Enter jumps to matching } and opens new line
inoremap <M-CR> <C-o>]}<C-o>o

" Insert mode: Ctrl-End jumps to end of file and opens new line
inoremap <C-End> <C-o>G<C-o>o

" Essential shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
nnoremap <leader>/ :nohlsearch<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Better indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" File explorer (legacy netrw - now replaced by NERDTree)
" nnoremap <leader>e :Explore<CR>
" nnoremap <leader>E :Vexplore<CR>

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ============================================================================
" NvChad-like Key Mappings
" ============================================================================

" File explorer (NERDTree)
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" Terminal (Neoterm)
nnoremap <leader>t :Tnew<CR>
nnoremap <leader>v :vertical Tnew<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>ba :bufdo bd<CR>

" Quick comment toggle
nmap <leader>/ <Plug>NERDCommenterToggle
vmap <leader>/ <Plug>NERDCommenterToggle

" Plugin management
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>pc :PlugClean<CR>

" ============================================================================
" File Explorer Settings (netrw)
" ============================================================================

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" ============================================================================
" Auto-commands
" ============================================================================

augroup MyAutoCommands
    autocmd!
    
    " Return to last cursor position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    
    " Remove trailing whitespace on save (42 norm compliance)
    autocmd BufWritePre * :%s/\s\+$//e
    
    " Auto-source vimrc when saved
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    
    " 42 specific: ensure proper file endings
    autocmd BufWritePre *.c,*.h set fileformat=unix
    autocmd BufWritePre *.c,*.h set fileencoding=utf-8
    
    " Highlight TODO, FIXME, NOTE in comments
    autocmd BufWinEnter * match Todo /\v<(TODO|FIXME|NOTE)/
augroup END

" ============================================================================
" Status Line
" ============================================================================

set statusline=%F%m%r%h%w\ 
set statusline+=[%{&ff}]
set statusline+=[%Y]
set statusline+=[%04l,%04v]
set statusline+=[%p%%]
set statusline+=\ %{strftime(\"%H:%M\")}

" ============================================================================
" 42 Helper Functions
" ============================================================================

" Quick compilation for C files
function! CompileC()
    if &filetype == 'c'
        let filename = expand('%:r')
        execute '!gcc -Wall -Wextra -Werror -o ' . filename . ' ' . expand('%')
    else
        echo "Not a C file!"
    endif
endfunction

" Norminette check
function! CheckNorm()
    if &filetype == 'c' || &filetype == 'cpp'
        execute '!norminette ' . expand('%')
    else
        echo "Not a C/C++ file!"
    endif
endfunction

" Map functions to keys
nnoremap <leader>cc :call CompileC()<CR>
nnoremap <leader>cn :call CheckNorm()<CR>

" ============================================================================
" Terminal Support (Vim 8+)
" ============================================================================

if has('terminal')
    " Horizontal terminal toggle (opens below)
    nnoremap <leader>h :call ToggleHorizontalTerminal()<CR>
    
    " Close terminal window 
    tnoremap <leader>x <C-\><C-n><C-w>c
    tnoremap <leader>q <C-\><C-n><C-w>c
    
    " Terminal navigation
    tnoremap <C-j> <C-\><C-n><C-w>k
    tnoremap <C-k> <C-\><C-n><C-w>j
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-l> <C-\><C-n><C-w>l
endif

" Function to toggle horizontal terminal
function! ToggleHorizontalTerminal()
    " Check if there's already a terminal buffer
    let term_buf = -1
    for buf in range(1, bufnr('$'))
        if getbufvar(buf, '&buftype') == 'terminal'
            let term_buf = buf
            break
        endif
    endfor
    
    " If terminal exists, check if it's visible
    if term_buf != -1
        let term_win = bufwinnr(term_buf)
        if term_win != -1
            " Terminal is visible, close it
            execute term_win . 'close'
            return
        endif
    endif
    
    " Open horizontal terminal at bottom
    botright split
    if term_buf != -1
        " Reuse existing terminal buffer
        execute 'buffer ' . term_buf
    else
        " Create new terminal
        terminal
    endif
    resize 12
endfunction


