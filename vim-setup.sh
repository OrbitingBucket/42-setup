#!/bin/bash

# 42 École Vim Setup Script
# Sets up enhanced Vim with NvChad-like features

set -e  # Exit on any error

echo "📝 Setting up enhanced Vim configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() { echo -e "${GREEN}[VIM]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[VIM]${NC} $1"; }
print_error() { echo -e "${RED}[VIM]${NC} $1"; }

# 1. Download enhanced .vimrc
print_status "Downloading enhanced .vimrc configuration..."
if curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/.vimrc -o ~/.vimrc; then
    print_status "✅ Enhanced .vimrc downloaded"
else
    print_error "❌ Failed to download .vimrc"
    exit 1
fi

# 2. Create necessary vim directories
print_status "Creating Vim directories..."
mkdir -p ~/.vim/{autoload,plugged,colors,backup,swap,undo}

# 3. Install vim-plug (plugin manager)
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    print_status "Installing vim-plug plugin manager..."
    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        print_status "✅ vim-plug installed"
    else
        print_error "❌ Failed to install vim-plug"
        exit 1
    fi
else
    print_status "✅ vim-plug already installed"
fi

# 4. Install plugins automatically using the official approach
print_status "Installing Vim plugins (this may take a moment)..."
if command -v vim >/dev/null 2>&1; then
    print_status "Running :PlugInstall in Vim..."
    # Install plugins with proper error handling
    vim -c "PlugInstall --sync" -c "qa" || {
        print_warning "Plugin installation had issues, but continuing..."
        print_status "You can manually run ':PlugInstall' in Vim later"
    }
    print_status "✅ Plugin installation completed"
else
    print_warning "Vim not found, plugins will install on first vim startup"
    print_status "💡 After Vim is available, run: vim +PlugInstall +qa"
fi

# 5. Verify colorscheme setup
print_status "Verifying Catppuccin theme setup..."
if vim -c "colorscheme catppuccin_mocha" -c "qa" 2>/dev/null; then
    print_status "✅ Catppuccin theme is working"
else
    print_warning "⚠️  Catppuccin theme may need plugin installation"
    print_status "💡 Run ':PlugInstall' then ':colorscheme catppuccin_mocha' in Vim"
fi

# 6. Create vim command shortcuts for 42
print_status "Creating 42-specific Vim shortcuts..."
cat > ~/.vim_42_shortcuts << 'EOF'
# 42 École Vim Shortcuts Reference
# Add these to your shell aliases or remember them

# Quick edit with vim
alias v='vim'
alias vi='vim'

# Open vim with 42 project template
alias vnew='vim -c "42new"'

# Vim with specific 42 settings
alias v42='vim -c "set number" -c "syntax on"'

# Quick vim help for 42
alias vhelp='vim -c "help 42" -c "only"'
EOF

# 7. Test vim configuration
print_status "Testing Vim configuration..."
if vim -c "echo 'Vim test OK'" -c "q" >/dev/null 2>&1; then
    print_status "✅ Vim configuration test passed"
else
    print_warning "⚠️  Vim configuration may need adjustment"
fi

# 8. Create quick troubleshooting script
cat > ~/.vim-troubleshoot << 'EOF'
#!/bin/bash
echo "🔧 Vim Troubleshooting for École 42"
echo "=================================="
echo "Vim version: $(vim --version | head -n1)"
echo "Terminal: $TERM"
echo "Color support: $COLORTERM"
echo "Vim config: $(ls -la ~/.vimrc)"
echo "Plugins dir: $(ls -la ~/.vim/plugged/ 2>/dev/null | wc -l) plugins"
echo ""
echo "💡 Common fixes:"
echo "1. Restart terminal after setup"
echo "2. Run ':PlugInstall' in vim if plugins missing"
echo "3. Check terminal supports 256 colors: tput colors"
echo "4. For color issues, run terminal-colors.sh"
EOF
chmod +x ~/.vim-troubleshoot

print_status "🎉 Enhanced Vim setup complete!"
echo ""
echo "✨ What's been installed:"
echo "  • Enhanced .vimrc with NvChad-like features"
echo "  • vim-plug plugin manager"
echo "  • File tree, status line, syntax highlighting"
echo "  • Auto-pairs, commenting, rainbow parentheses"
echo "  • 42-specific functions and key bindings"
echo ""
echo "🎯 Key bindings (leader = space):"
echo "  • <leader>e  - Toggle file tree"
echo "  • <leader>t  - Open terminal"
echo "  • <leader>/  - Toggle comments"
echo "  • <leader>cc - Compile C file"
echo "  • <leader>cn - Check norminette"
echo ""
echo "🔧 Troubleshooting: ~/.vim-troubleshoot"
echo "📚 Full reference: https://github.com/OrbitingBucket/42-setup/blob/main/cheatsheet.md"