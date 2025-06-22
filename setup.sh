#!/bin/bash

# 42 École Setup Script - Environment Only
# Usage: curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup.sh | bash

set -e  # Exit on any error

# Initialize issue counter
issues=0

echo "🚀 Setting up 42 environment..."

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

# Download Catppuccin terminal color config
curl -sSL "$REPO_URL/.catppuccin-mocha.conf" -o ~/.catppuccin-mocha.conf || print_warning "Could not download terminal color config"

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

# 4. Change default shell to zsh (if available)
if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Changing default shell to zsh..."
    chsh -s $(which zsh) || print_warning "Could not change shell (may need sudo)"
fi

# 5. Create useful aliases file
print_status "Creating 42 aliases..."
cat > ~/.42_aliases << 'EOF'
# 42 Specific aliases
alias 42='cd ~/code/42'
alias code='cd ~/code'
alias tmp='cd ~/code/tmp'

# Development
alias cc='gcc -Wall -Wextra -Werror'
alias ccg='gcc -Wall -Wextra -Werror -g'
alias norm='norminette'
alias valg='valgrind --leak-check=full --show-leak-kinds=all'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --all'

# Utilities
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias v='vim'
alias +x='chmod +x'
alias reload='source ~/.zshrc || source ~/.bashrc'

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }
backup() { cp "$1"{,.bak}; }
compile() { gcc -Wall -Wextra -Werror -o "${1%.*}" "$1"; }
EOF

# Source aliases in shell configs
if ! grep -q "source ~/.42_aliases" ~/.bashrc 2>/dev/null; then
    echo "source ~/.42_aliases" >> ~/.bashrc
fi
if [ -f ~/.zshrc ] && ! grep -q "source ~/.42_aliases" ~/.zshrc 2>/dev/null; then
    echo "source ~/.42_aliases" >> ~/.zshrc
fi

# 6. Health Check
print_status "Running health check..."

health_check() {
    local issues=0
    
    echo ""
    echo "=== 42 Environment Health Check ==="
    echo ""
    
    # Check Shell
    echo "🐚 Shell Configuration:"
    echo "  ✅ Current shell: $SHELL"
    if command -v zsh >/dev/null 2>&1; then
        if [ -d "$HOME/.oh-my-zsh" ]; then
            echo "  ✅ Oh My Zsh installed"
        else
            echo "  ⚠️  Oh My Zsh not installed"
        fi
    else
        echo "  ⚠️  Zsh not available (using bash)"
    fi
    
    # Check Vim
    echo ""
    echo "📝 Editor Configuration:"
    if [ -f ~/.vimrc ]; then
        echo "  ✅ Vim configuration found"
    else
        echo "  ❌ Vim configuration missing"
        ((issues++))
    fi
    
    # Check directory structure
    echo ""
    echo "📁 Directory Structure:"
    for dir in ~/code ~/code/42 ~/code/personal ~/code/tmp; do
        if [ -d "$dir" ]; then
            echo "  ✅ $dir"
        else
            echo "  ❌ $dir missing"
            ((issues++))
        fi
    done
    
    # Check aliases
    echo ""
    echo "⚡ Aliases and Functions:"
    if [ -f ~/.42_aliases ]; then
        echo "  ✅ 42 aliases file created"
        if grep -q "source ~/.42_aliases" ~/.bashrc 2>/dev/null || grep -q "source ~/.42_aliases" ~/.zshrc 2>/dev/null; then
            echo "  ✅ Aliases sourced in shell config"
        else
            echo "  ❌ Aliases not sourced in shell config"
            ((issues++))
        fi
    else
        echo "  ❌ Aliases file missing"
        ((issues++))
    fi
    
    # Check development tools
    echo ""
    echo "🛠️  Development Tools:"
    local tools=("gcc" "make" "git" "vim" "curl" "unzip")
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "  ✅ $tool available"
        else
            echo "  ❌ $tool missing"
            ((issues++))
        fi
    done
    
    # Check fonts
    echo ""
    echo "🔤 Fonts:"
    if [ -d "$HOME/.local/share/fonts" ] && find "$HOME/.local/share/fonts" -name "*JetBrains*" -type f | grep -q .; then
        echo "  ✅ JetBrainsMono Nerd Font installed"
    else
        echo "  ❌ JetBrainsMono Nerd Font missing"
        ((issues++))
    fi
    
    # Check color configuration
    echo ""
    echo "🎨 Theme Configuration:"
    if [ -f ~/.catppuccin-mocha.conf ]; then
        echo "  ✅ Catppuccin terminal colors available"
    else
        echo "  ❌ Terminal color config missing"
        ((issues++))
    fi
    
    # Check disk space
    echo ""
    echo "💾 System Resources:"
    local available_space=$(df -h ~ | tail -1 | awk '{print $4}')
    echo "  ✅ Available disk space: $available_space"
    
    # Summary
    echo ""
    echo "========================="
    if [ $issues -eq 0 ]; then
        echo "🎉 Health Check: ALL SYSTEMS GO!"
        echo "✅ No issues found - your environment is ready for 42!"
    elif [ $issues -eq 1 ]; then
        echo "⚠️  Health Check: 1 minor issue found"
        echo "🔧 Your environment should work fine, but consider fixing the issue above"
    else
        echo "❌ Health Check: $issues issues found"
        echo "🔧 Please review and fix the issues above"
    fi
    echo "========================="
    
    return $issues
}

# Run the health check
health_check
health_result=$?

print_status "✅ Environment setup complete!"
echo ""
echo "📋 Next Steps:"
echo "1. 🔧 Configure Git:"
echo "   curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/git-setup.sh | bash"
echo ""
echo "2. 🎨 Configure Terminal Theme:"
echo "   cat ~/.catppuccin-mocha.conf  # view color configuration"
echo "   # Manual: Set terminal to use JetBrainsMono Nerd Font and Catppuccin colors"
echo ""
echo "3. 🚀 Quick start:"
echo "   source ~/.bashrc  # or restart terminal"
echo "   42               # go to projects directory"
echo "   cc --version     # test compiler setup"
echo ""

# Provide next steps based on health check
if [ $health_result -eq 0 ]; then
    print_status "🚀 Environment ready! Configure Git and start coding! 🎓"
else
    print_warning "⚠️  Some issues detected. Run health check again:"
    echo "   curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash"
fi
