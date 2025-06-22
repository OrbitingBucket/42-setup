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
" Catppuccin Mocha Color Scheme
" ============================================================================

" Define Catppuccin Mocha colors (matching Alacritty config)
let g:catppuccin_mocha = {
    \ 'rosewater': '#f5e0dc',
    \ 'flamingo':  '#f2cdcd',
    \ 'pink':      '#f5c2e7',
    \ 'mauve':     '#cba6f7',
    \ 'red':       '#f38ba8',
    \ 'maroon':    '#eba0ac',
    \ 'peach':     '#fab387',
    \ 'yellow':    '#f9e2af',
    \ 'green':     '#a6e3a1',
    \ 'teal':      '#94e2d5',
    \ 'sky':       '#89dceb',
    \ 'sapphire':  '#74c7ec',
    \ 'blue':      '#89b4fa',
    \ 'lavender':  '#b4befe',
    \ 'text':      '#cdd6f4',
    \ 'subtext1':  '#bac2de',
    \ 'subtext0':  '#a6adc8',
    \ 'overlay2':  '#9399b2',
    \ 'overlay1':  '#7f849c',
    \ 'overlay0':  '#6c7086',
    \ 'surface2':  '#585b70',
    \ 'surface1':  '#45475a',
    \ 'surface0':  '#313244',
    \ 'base':      '#1e1e2e',
    \ 'mantle':    '#181825',
    \ 'crust':     '#11111b',
    \ }

" Set terminal colors to match GNOME Terminal/Alacritty
set t_Co=256
if &term =~# '^xterm' || &term =~# '^screen' || &term =~# '^tmux'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Apply Catppuccin Mocha theme
function! CatppuccinMocha()
  set background=dark
  
  " Clear existing highlights
  highlight clear
  if exists("syntax_on")
    syntax reset
  endif
  
  let g:colors_name = "catppuccin-mocha"
  
  " UI Elements
  exec 'highlight Normal guifg=' . g:catppuccin_mocha.text . ' guibg=' . g:catppuccin_mocha.base
  exec 'highlight LineNr guifg=' . g:catppuccin_mocha.overlay1 . ' guibg=' . g:catppuccin_mocha.base
  exec 'highlight CursorLineNr guifg=' . g:catppuccin_mocha.lavender . ' guibg=' . g:catppuccin_mocha.base . ' gui=bold'
  exec 'highlight CursorLine guibg=' . g:catppuccin_mocha.surface0
  exec 'highlight Visual guibg=' . g:catppuccin_mocha.surface1
  exec 'highlight StatusLine guifg=' . g:catppuccin_mocha.text . ' guibg=' . g:catppuccin_mocha.mantle
  exec 'highlight StatusLineNC guifg=' . g:catppuccin_mocha.overlay1 . ' guibg=' . g:catppuccin_mocha.mantle
  exec 'highlight VertSplit guifg=' . g:catppuccin_mocha.overlay0 . ' guibg=' . g:catppuccin_mocha.base
  exec 'highlight Pmenu guifg=' . g:catppuccin_mocha.text . ' guibg=' . g:catppuccin_mocha.surface0
  exec 'highlight PmenuSel guifg=' . g:catppuccin_mocha.text . ' guibg=' . g:catppuccin_mocha.surface1
  exec 'highlight Search guifg=' . g:catppuccin_mocha.base . ' guibg=' . g:catppuccin_mocha.yellow
  exec 'highlight IncSearch guifg=' . g:catppuccin_mocha.base . ' guibg=' . g:catppuccin_mocha.peach
  
  " Syntax highlighting
  exec 'highlight Comment guifg=' . g:catppuccin_mocha.overlay1 . ' gui=italic'
  exec 'highlight Constant guifg=' . g:catppuccin_mocha.peach
  exec 'highlight String guifg=' . g:catppuccin_mocha.green
  exec 'highlight Character guifg=' . g:catppuccin_mocha.teal
  exec 'highlight Number guifg=' . g:catppuccin_mocha.peach
  exec 'highlight Boolean guifg=' . g:catppuccin_mocha.peach
  exec 'highlight Float guifg=' . g:catppuccin_mocha.peach
  exec 'highlight Identifier guifg=' . g:catppuccin_mocha.flamingo
  exec 'highlight Function guifg=' . g:catppuccin_mocha.blue
  exec 'highlight Statement guifg=' . g:catppuccin_mocha.mauve
  exec 'highlight Conditional guifg=' . g:catppuccin_mocha.red
  exec 'highlight Repeat guifg=' . g:catppuccin_mocha.red
  exec 'highlight Label guifg=' . g:catppuccin_mocha.peach
  exec 'highlight Operator guifg=' . g:catppuccin_mocha.sky
  exec 'highlight Keyword guifg=' . g:catppuccin_mocha.pink
  exec 'highlight Exception guifg=' . g:catppuccin_mocha.peach
  exec 'highlight PreProc guifg=' . g:catppuccin_mocha.pink
  exec 'highlight Include guifg=' . g:catppuccin_mocha.pink
  exec 'highlight Define guifg=' . g:catppuccin_mocha.pink
  exec 'highlight Macro guifg=' . g:catppuccin_mocha.pink
  exec 'highlight PreCondit guifg=' . g:catppuccin_mocha.pink
  exec 'highlight Type guifg=' . g:catppuccin_mocha.yellow
  exec 'highlight StorageClass guifg=' . g:catppuccin_mocha.yellow
  exec 'highlight Structure guifg=' . g:catppuccin_mocha.yellow
  exec 'highlight Typedef guifg=' . g:catppuccin_mocha.yellow
  exec 'highlight Special guifg=' . g:catppuccin_mocha.pink
  exec 'highlight SpecialChar guifg=' . g:catppuccin_mocha.pink
  exec 'highlight Tag guifg=' . g:catppuccin_mocha.peach
  exec 'highlight Delimiter guifg=' . g:catppuccin_mocha.overlay2
  exec 'highlight SpecialComment guifg=' . g:catppuccin_mocha.overlay1 . ' gui=italic'
  exec 'highlight Debug guifg=' . g:catppuccin_mocha.peach
  exec 'highlight Error guifg=' . g:catppuccin_mocha.red
  exec 'highlight Todo guifg=' . g:catppuccin_mocha.base . ' guibg=' . g:catppuccin_mocha.yellow . ' gui=bold'
  
  " Diff colors
  exec 'highlight DiffAdd guifg=' . g:catppuccin_mocha.green . ' guibg=' . g:catppuccin_mocha.base
  exec 'highlight DiffChange guifg=' . g:catppuccin_mocha.yellow . ' guibg=' . g:catppuccin_mocha.base
  exec 'highlight DiffDelete guifg=' . g:catppuccin_mocha.red . ' guibg=' . g:catppuccin_mocha.base
  exec 'highlight DiffText guifg=' . g:catppuccin_mocha.blue . ' guibg=' . g:catppuccin_mocha.base
  
  " Git colors
  exec 'highlight GitGutterAdd guifg=' . g:catppuccin_mocha.green
  exec 'highlight GitGutterChange guifg=' . g:catppuccin_mocha.yellow
  exec 'highlight GitGutterDelete guifg=' . g:catppuccin_mocha.red
endfunction

" Apply the theme
call CatppuccinMocha()

" ============================================================================
" Plugin Configurations
" ============================================================================

" Lightline (status bar)
let g:lightline = {
      \ 'colorscheme': 'catppuccin_mocha',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

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

" Rainbow parentheses
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
nnoremap <leader>th :Tnew<CR>
nnoremap <leader>tv :vnew \| :terminal<CR>

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
    nnoremap <leader>t :terminal<CR>
    nnoremap <leader>th :split \| terminal<CR>
    
    " Close terminal window with <leader>tx
    tnoremap <leader>tx <C-\><C-n><C-w>c
    
    " Terminal navigation: Ctrl-j goes up, Ctrl-k goes down
    tnoremap <C-j> <C-\><C-n><C-w>k
    tnoremap <C-k> <C-\><C-n><C-w>j
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-l> <C-\><C-n><C-w>l
endif


