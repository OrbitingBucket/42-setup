#!/bin/bash

# 42 École Vim Setup Module
# Configures enhanced Vim with NvChad-like features

# ============================================================================
# Configuration
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_module_status() { echo -e "${GREEN}[VIM]${NC} $1"; }
print_module_warning() { echo -e "${YELLOW}[VIM]${NC} $1"; }
print_module_error() { echo -e "${RED}[VIM]${NC} $1"; }

# Configuration URLs
REPO_URL="https://raw.githubusercontent.com/OrbitingBucket/42-setup/main"
VIMRC_URL="$REPO_URL/configs/.vimrc"
VIMPLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# ============================================================================
# Vim-plug Installation Functions
# ============================================================================

install_vim_plug() {
    print_module_status "Installing vim-plug plugin manager..."
    
    local plug_file="$HOME/.vim/autoload/plug.vim"
    
    # Check if vim-plug is already installed
    if [[ -f "$plug_file" ]]; then
        print_module_status "✅ vim-plug already installed"
        return 0
    fi
    
    # Create necessary directories
    mkdir -p "$HOME/.vim/autoload"
    mkdir -p "$HOME/.vim/plugged"
    
    # Download vim-plug
    if command -v curl >/dev/null 2>&1; then
        if curl -fLo "$plug_file" --create-dirs "$VIMPLUG_URL"; then
            print_module_status "✅ vim-plug installed successfully"
            return 0
        else
            print_module_error "Failed to download vim-plug"
            return 1
        fi
    else
        print_module_error "curl not available for vim-plug installation"
        return 1
    fi
}

# ============================================================================
# Vim Configuration Functions
# ============================================================================

create_vim_config() {
    print_module_status "Creating enhanced Vim configuration..."
    
    # Check if we have the enhanced .vimrc in the repo
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local vimrc_source="$script_dir/../.vimrc"
    
    if [[ -f "$vimrc_source" ]]; then
        print_module_status "Using enhanced .vimrc from repository..."
        cp "$vimrc_source" "$HOME/.vimrc"
        print_module_status "✅ Enhanced .vimrc installed"
        return 0
    fi
    
    print_module_status "Repository .vimrc not found, creating fallback configuration..."
    
    # Create fallback .vimrc configuration
    cat > "$HOME/.vimrc" << 'EOF'
" 42 École Vim Configuration
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
Plug 'ryanoasis/vim-devicons'                  " File icons (needs Nerd Font)

" File explorer
Plug 'preservim/nerdtree'                      " File tree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Syntax colors in NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'            " Git status in NERDTree

" Editing enhancements
Plug 'jiangmiao/auto-pairs'                    " Auto-close brackets/quotes
Plug 'tpope/vim-surround'                      " Surround text with quotes/brackets
Plug 'preservim/nerdcommenter'                 " Smart commenting
Plug 'luochen1990/rainbow'                     " Rainbow parentheses

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
set fillchars=vert:\|,fold:-,eob:\ 

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
" Catppuccin Theme Configuration
" ============================================================================

" Enable true color support
set termguicolors
set background=dark

" Apply Catppuccin Mocha colorscheme (after plugins are loaded)
augroup LoadColorScheme
    autocmd!
    autocmd VimEnter * ++nested colorscheme catppuccin_mocha
augroup END

" ============================================================================
" Plugin Configurations
" ============================================================================

" Lightline (status bar)
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

" ============================================================================
" 42 Specific Settings
" ============================================================================

" Highlight line length limit (42 norm: 80 characters)
highlight ColorColumn ctermbg=red guibg=#ff6b6b
call matchadd('ColorColumn', '\%81v', 100)

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

" Custom bindings for École 42
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

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" ============================================================================
" NvChad-like Key Mappings
" ============================================================================

" File explorer (NERDTree)
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

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
" Terminal Support (Vim 8+)
" ============================================================================

if has('terminal')
    " Horizontal terminal toggle (opens below)
    nnoremap <leader>h :call ToggleHorizontalTerminal()<CR>
    
    " Exit terminal mode and close terminal window
    tnoremap <leader>h <C-\><C-n>:call ToggleHorizontalTerminal()<CR>
    tnoremap <leader>x <C-\><C-n><C-w>c
    tnoremap <leader>q <C-\><C-n><C-w>c
    tnoremap <Esc><Esc> <C-\><C-n>
    
    " Terminal navigation (exit terminal mode first)
    tnoremap <C-j> <C-\><C-n><C-w>k
    tnoremap <C-k> <C-\><C-n><C-w>j
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-l> <C-\><C-n><C-w>l
endif

" Function to toggle horizontal terminal
function! ToggleHorizontalTerminal()
    " Check if there's already a terminal window open
    for winnr in range(1, winnr('$'))
        if getbufvar(winbufnr(winnr), '&buftype') == 'terminal'
            " Terminal window found, close it
            execute winnr . 'close'
            return
        endif
    endfor
    
    " No terminal window found, open one at the bottom
    " Save current window to return focus
    let current_win = winnr()
    
    " Open horizontal split at bottom (takes full width)
    botright split
    
    " Set fixed height for terminal
    resize 15
    
    " Create new terminal
    terminal
    
    " Configure terminal window settings
    setlocal nonumber
    setlocal norelativenumber
    setlocal nospell
    setlocal bufhidden=hide
    
    " Start in terminal mode
    startinsert
endfunction

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
EOF
    
    print_module_status "✅ Enhanced .vimrc created"
}

# ============================================================================
# Plugin Installation Functions
# ============================================================================

install_vim_plugins() {
    print_module_status "Installing Vim plugins..."
    
    if ! command -v vim >/dev/null 2>&1; then
        print_module_error "Vim not found"
        return 1
    fi
    
    # Create required directories
    mkdir -p "$HOME/.vim/undo"
    
    # Check if xclip is available for clipboard support
    if ! command -v xclip >/dev/null 2>&1; then
        print_module_warning "xclip not found - clipboard integration may not work"
        print_module_status "Install xclip for clipboard support: sudo apt install xclip"
    fi
    
    # Install plugins using vim-plug
    print_module_status "Running :PlugInstall..."
    if vim -c "PlugInstall --sync" -c "qa" >/dev/null 2>&1; then
        print_module_status "✅ Plugins installed successfully"
        return 0
    else
        print_module_warning "Plugin installation may have had issues"
        print_module_status "You can run ':PlugInstall' manually in Vim"
        return 1
    fi
}

# ============================================================================
# Verification Functions
# ============================================================================

verify_vim_setup() {
    print_module_status "Verifying Vim setup..."
    
    local issues=()
    
    # Check if .vimrc exists
    if [[ -f "$HOME/.vimrc" ]]; then
        print_module_status "✅ Configuration: .vimrc found"
    else
        issues+=(".vimrc not found")
    fi
    
    # Check if vim-plug is installed
    if [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
        print_module_status "✅ Plugin manager: vim-plug installed"
    else
        issues+=("vim-plug not installed")
    fi
    
    # Check if plugins directory exists
    if [[ -d "$HOME/.vim/plugged" ]]; then
        local plugin_count=$(ls -1 "$HOME/.vim/plugged" 2>/dev/null | wc -l)
        print_module_status "✅ Plugins: $plugin_count plugins directory found"
    else
        issues+=("Plugins directory not found")
    fi
    
    # Test Vim basic functionality
    if command -v vim >/dev/null 2>&1; then
        if vim -c "echo 'test'" -c "qa" >/dev/null 2>&1; then
            print_module_status "✅ Functionality: Vim loads correctly"
        else
            issues+=("Vim has loading issues")
        fi
    else
        issues+=("Vim command not found")
    fi
    
    # Check colorscheme
    if vim -c "try | colorscheme catppuccin_mocha | echo 'OK' | catch | echo 'FAIL' | endtry" -c "qa" 2>/dev/null | grep -q "OK"; then
        print_module_status "✅ Theme: Catppuccin theme loads correctly"
    else
        issues+=("Catppuccin theme not available")
    fi
    
    # Report results
    if [[ ${#issues[@]} -eq 0 ]]; then
        print_module_status "✅ Vim setup verification passed"
        return 0
    else
        print_module_warning "Vim setup has issues:"
        for issue in "${issues[@]}"; do
            print_module_warning "  - $issue"
        done
        return 1
    fi
}

create_vim_cheatsheet() {
    print_module_status "Creating Vim cheatsheet..."
    
    cat > "$HOME/.vim-42-cheatsheet.md" << 'EOF'
# 42 École Vim Cheatsheet

## Leader Key
Leader key = `<space>` (spacebar)

## File Operations
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Force quit
- `<leader>ev` - Edit .vimrc
- `<leader>sv` - Reload .vimrc

## File Explorer (NERDTree)
- `<leader>e` - Toggle file tree
- `<leader>f` - Find current file in tree

### Inside NERDTree:
- `o` - Open file/folder
- `t` - Open in new tab
- `s` - Open in vertical split
- `i` - Open in horizontal split
- `m` - Show menu (create/delete/rename)
- `R` - Refresh tree

## Terminal
- `<leader>h` - Toggle horizontal terminal (bottom, full width)
- `<leader>h` - Close terminal (when inside terminal)
- `<leader>x` - Close terminal (from inside terminal)
- `<leader>q` - Close terminal (from inside terminal)
- `Esc Esc` - Exit terminal mode (return to normal mode)

## Buffer Management
- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bd` - Delete buffer
- `<leader>ba` - Delete all buffers

## Comments
- `<leader>/` - Toggle comment (normal/visual mode)

## 42-Specific Functions
- `<leader>cc` - Compile C file with 42 flags
- `<leader>cn` - Check norminette

## Plugin Management
- `<leader>pi` - Install plugins
- `<leader>pu` - Update plugins
- `<leader>pc` - Clean plugins

## Custom Bindings
- `jk` - Exit insert mode
- `Alt+Enter` - Jump to matching `}` and open new line
- `Ctrl+End` - Jump to end of file and open new line
- `Alt+j/k` - Move lines up/down
- `;` - Enter command mode (same as `:`)

## Text Objects
- `di{` - Delete inside `{}`
- `da{` - Delete around `{}` (including braces)
- `ci"` - Change inside quotes
- `ysiw"` - Surround word with quotes (vim-surround)
- `cs"'` - Change `"` to `'` (vim-surround)
- `ds"` - Delete surrounding quotes

## Window Navigation
- `Ctrl+h/j/k/l` - Move between splits
- `Ctrl+arrows` - Resize splits

## Search & Replace
- `/pattern` - Search forward
- `?pattern` - Search backward
- `n/N` - Next/previous match
- `<leader>/` - Clear search highlighting
- `:%s/old/new/g` - Replace all

## Auto-pairs
Automatically closes:
- `(` → `()`
- `{` → `{}`
- `[` → `[]`
- `"` → `""`
- `'` → `''`
EOF
    
    print_module_status "✅ Cheatsheet saved to ~/.vim-42-cheatsheet.md"
}

# ============================================================================
# Main Vim Setup Function
# ============================================================================

main() {
    print_module_status "📝 Starting Vim configuration..."
    
    local errors=0
    
    # Install vim-plug
    if ! install_vim_plug; then
        ((errors++))
    fi
    
    # Create Vim configuration
    create_vim_config
    
    # Install plugins
    if ! install_vim_plugins; then
        ((errors++))
    fi
    
    # Create cheatsheet
    create_vim_cheatsheet
    
    # Verify setup
    if ! verify_vim_setup; then
        ((errors++))
    fi
    
    # Summary
    if [[ $errors -eq 0 ]]; then
        print_module_status "🎉 Vim module completed successfully!"
        print_module_status "💡 Key bindings: <space>h (terminal), <space>e (file tree)"
        print_module_status "📚 Cheatsheet: ~/.vim-42-cheatsheet.md"
    else
        print_module_warning "Vim module completed with $errors issue(s)"
        print_module_status "Run ':PlugInstall' in Vim if plugins didn't install"
    fi
    
    return $errors
}

# ============================================================================
# Script Entry Point
# ============================================================================

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi