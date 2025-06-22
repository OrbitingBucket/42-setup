#!/bin/bash

# 42 École Setup Script - No Shell Change Version
# Usage: curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup-no-chsh.sh | bash

set -e  # Exit on any error

# Initialize issue counter
issues=0

echo "🚀 Setting up 42 environment (no shell change)..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a 42 environment (optional)
if [[ $(hostname) != *"42"* ]] && [[ $(pwd) != *"/sgoinfre/"* ]]; then
    print_warning "This doesn't look like a 42 machine, but continuing anyway..."
fi

# 1. Create directory structure
print_status "Creating directory structure..."
mkdir -p ~/code/{42,personal,tmp}
mkdir -p ~/.config

# 2. Install Oh My Zsh (if zsh is available)
if command -v zsh >/dev/null 2>&1; then
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Install useful plugins
        print_status "Installing zsh plugins..."
        if ! git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null; then
            print_warning "Failed to install zsh-autosuggestions plugin"
        fi
        if ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null; then
            print_warning "Failed to install zsh-syntax-highlighting plugin"
        fi
    else
        print_status "Oh My Zsh already installed"
    fi
else
    print_warning "Zsh not available, skipping Oh My Zsh installation"
fi

# 3. Install JetBrainsMono Nerd Font
print_status "Installing JetBrainsMono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Download JetBrainsMono Nerd Font
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
TEMP_FONT_DIR="/tmp/jetbrains_font"

if command -v curl >/dev/null 2>&1; then
    if curl -L "$FONT_URL" -o "/tmp/JetBrainsMono.zip"; then
        mkdir -p "$TEMP_FONT_DIR"
        if command -v unzip >/dev/null 2>&1; then
            if unzip -q "/tmp/JetBrainsMono.zip" -d "$TEMP_FONT_DIR"; then
                # Copy font files to user font directory
                find "$TEMP_FONT_DIR" -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
                # Update font cache if fc-cache is available
                if command -v fc-cache >/dev/null 2>&1; then
                    fc-cache -f "$FONT_DIR"
                    print_status "JetBrainsMono Nerd Font installed and cache updated"
                else
                    print_status "JetBrainsMono Nerd Font installed (cache update requires fc-cache)"
                fi
                # Cleanup
                rm -rf "$TEMP_FONT_DIR" "/tmp/JetBrainsMono.zip"
            else
                print_warning "Failed to extract font archive"
                rm -f "/tmp/JetBrainsMono.zip"
            fi
        else
            print_warning "unzip not available, skipping font installation"
            rm -f "/tmp/JetBrainsMono.zip"
        fi
    else
        print_warning "Failed to download JetBrainsMono Nerd Font"
    fi
else
    print_warning "curl not available, skipping font installation"
fi

# 4. Set up enhanced Vim configuration
print_status "Setting up enhanced Vim configuration..."
REPO_URL="https://raw.githubusercontent.com/OrbitingBucket/42-setup/main"

# Run dedicated vim setup script
if curl -sSL "$REPO_URL/vim-setup.sh" | bash; then
    print_status "✅ Enhanced Vim setup completed"
else
    print_warning "⚠️  Vim setup encountered issues, but continuing..."
    # Fallback: download basic .vimrc
    if ! curl -sSL "$REPO_URL/.vimrc" -o ~/.vimrc; then
        print_error "Failed to download .vimrc"
        ((issues++))
    else
        print_status "Downloaded basic .vimrc configuration"
    fi
fi

# Download .zshrc additions
if command -v zsh >/dev/null 2>&1; then
    if curl -sSL "$REPO_URL/.zshrc" -o ~/.zshrc.42; then
        if [ -f ~/.zshrc.42 ]; then
            # Backup existing .zshrc if it exists
            if [ -f ~/.zshrc ]; then
                cp ~/.zshrc ~/.zshrc.backup
                print_status "Backed up existing .zshrc to .zshrc.backup"
            fi
            # Append to existing .zshrc
            echo "" >> ~/.zshrc
            echo "# 42 Custom configurations" >> ~/.zshrc
            cat ~/.zshrc.42 >> ~/.zshrc
            rm ~/.zshrc.42
            print_status "Added 42 configurations to .zshrc"
        fi
    else
        print_warning "Failed to download .zshrc configuration"
    fi
fi

# 5. Create useful aliases file (NO SHELL CHANGE)
print_status "Creating 42 aliases..."
cat > ~/.42_aliases << 'EOF'
# 42 Specific aliases
alias 42='cd ~/code/42'
alias code='cd ~/code'
alias tmp='cd ~/code/tmp'
alias reload='source ~/.bashrc && source ~/.zshrc 2>/dev/null || source ~/.bashrc'

# Development shortcuts
alias cc='gcc -Wall -Wextra -Werror'
alias ccg='gcc -Wall -Wextra -Werror -g'
alias norm='norminette'
alias valg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'
alias gundo='git reset --soft HEAD~1'

# Utility shortcuts
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias mkcd='mkdir -p "$1" && cd "$1"'
EOF

# 6. Source aliases in shell configs
print_status "Configuring shell aliases..."

# Add to .bashrc
if ! grep -q "source ~/.42_aliases" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# 42 École aliases" >> ~/.bashrc
    echo "[ -f ~/.42_aliases ] && source ~/.42_aliases" >> ~/.bashrc
    echo "export TERM=xterm-256color" >> ~/.bashrc
    echo "export COLORTERM=truecolor" >> ~/.bashrc
    print_status "Added aliases to .bashrc"
fi

# Add to .zshrc if it exists
if [ -f ~/.zshrc ] && ! grep -q "source ~/.42_aliases" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# 42 École aliases" >> ~/.zshrc
    echo "[ -f ~/.42_aliases ] && source ~/.42_aliases" >> ~/.zshrc
    echo "export TERM=xterm-256color" >> ~/.zshrc
    echo "export COLORTERM=truecolor" >> ~/.zshrc
    print_status "Added aliases to .zshrc"
fi

# 7. Run health check
print_status "Running health check..."
if curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash; then
    print_status "Health check completed"
else
    print_warning "Health check had issues"
fi

print_status "🎉 Environment setup complete!"
echo ""
echo "💡 Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. To use zsh: just type 'zsh'"
echo "3. To make zsh default: chsh -s \$(which zsh)"
echo "4. Test vim colors: vim test.c"
echo ""
echo "🔧 If you have issues:"
echo "- Check colors: tput colors"
echo "- Verify TERM: echo \$TERM"
echo "- Run health check: curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash"