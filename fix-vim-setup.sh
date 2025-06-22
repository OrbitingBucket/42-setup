#!/bin/bash

# 42 École Vim Setup Fix Script
# Automatically fixes common Vim setup issues

echo "🔧 Fixing Vim setup issues..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 1. Download latest .vimrc
print_status "Downloading latest .vimrc configuration..."
if curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/.vimrc -o ~/.vimrc; then
    print_status "✅ Downloaded .vimrc"
else
    print_error "❌ Failed to download .vimrc"
    exit 1
fi

# 2. Fix any potential encoding issues with École character
print_status "Fixing encoding issues..."
sed -i 's/\\Uffffffffole/École/g' ~/.vimrc

# 3. Install vim-plug if missing
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    print_status "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    print_status "✅ vim-plug installed"
else
    print_status "✅ vim-plug already installed"
fi

# 4. Create vim directories
mkdir -p ~/.vim/{autoload,plugged,colors}

# 5. Fix terminal color support for better color matching with Neovim
print_status "Enhancing terminal color support..."

# Add terminal color enhancements to .vimrc
cat >> ~/.vimrc << 'EOF'

" ============================================================================
" Enhanced Terminal Color Support (to match Neovim)
" ============================================================================

" Force 256 colors and true color support
set t_Co=256
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Set TERM for better color support
if &term == 'xterm' || &term == 'screen' || &term == 'tmux-256color'
    set term=xterm-256color
endif

" Force color mode
if has('gui_running') || &t_Co >= 256 || has('termguicolors')
    set background=dark
endif

EOF

# 6. Test vim configuration
print_status "Testing Vim configuration..."
if vim -c "syntax on" -c "q" 2>/dev/null; then
    print_status "✅ Vim configuration test passed"
else
    print_warning "⚠️  Vim configuration may have issues"
fi

# 7. Install plugins automatically
print_status "Installing Vim plugins..."
if command -v vim >/dev/null 2>&1; then
    vim +PlugInstall +qall 2>/dev/null
    print_status "✅ Plugins installation attempted"
else
    print_error "❌ Vim not found"
fi

# 8. Create a simple color test script
cat > ~/.vim-color-test.sh << 'EOF'
#!/bin/bash
echo "🎨 Vim Color Test"
echo "Run this in vim: :so ~/.vim-color-test.vim"
EOF

cat > ~/.vim-color-test.vim << 'EOF'
" Vim Color Test
echo "Testing colors..."
echo "Red: " . g:catppuccin_mocha.red
echo "Green: " . g:catppuccin_mocha.green  
echo "Blue: " . g:catppuccin_mocha.blue
echo "Terminal colors: " . &t_Co
echo "True colors: " . (has('termguicolors') ? 'supported' : 'not supported')
EOF

chmod +x ~/.vim-color-test.sh

print_status "🎉 Vim setup fix complete!"
echo ""
echo "💡 Next steps:"
echo "1. Restart your terminal"
echo "2. Open vim and test: vim test.c"
echo "3. Check colors with: :so ~/.vim-color-test.vim"
echo "4. If colors still don't match, run terminal-colors.sh"
echo ""
echo "🔧 Troubleshooting:"
echo "- Run ~/.vim-color-test.sh for diagnostics"
echo "- Check: echo \$TERM (should be xterm-256color)"
echo "- Verify terminal supports true color"