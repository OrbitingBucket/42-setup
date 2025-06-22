#!/bin/bash

# 42 École Zsh Setup Module
# Configures Zsh with Oh My Zsh (manual activation, no shell change)

# ============================================================================
# Configuration
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_module_status() { echo -e "${GREEN}[ZSH]${NC} $1"; }
print_module_warning() { echo -e "${YELLOW}[ZSH]${NC} $1"; }
print_module_error() { echo -e "${RED}[ZSH]${NC} $1"; }

# Oh My Zsh configuration
OH_MY_ZSH_URL="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ============================================================================
# Oh My Zsh Installation Functions
# ============================================================================

install_oh_my_zsh() {
    print_module_status "Installing Oh My Zsh..."
    
    # Check if Zsh is available
    if ! command -v zsh >/dev/null 2>&1; then
        print_module_warning "Zsh not available, skipping Oh My Zsh installation"
        return 1
    fi
    
    # Check if Oh My Zsh is already installed
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_module_status "✅ Oh My Zsh already installed"
        return 0
    fi
    
    # Install Oh My Zsh (unattended mode)
    if sh -c "$(curl -fsSL $OH_MY_ZSH_URL)" "" --unattended; then
        print_module_status "✅ Oh My Zsh installed successfully"
        return 0
    else
        print_module_error "Failed to install Oh My Zsh"
        return 1
    fi
}

install_zsh_plugins() {
    print_module_status "Installing Zsh plugins..."
    
    local plugins_dir="$ZSH_CUSTOM/plugins"
    mkdir -p "$plugins_dir"
    
    # Install zsh-autosuggestions
    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        if git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"; then
            print_module_status "✅ zsh-autosuggestions installed"
        else
            print_module_warning "Failed to install zsh-autosuggestions"
        fi
    else
        print_module_status "✅ zsh-autosuggestions already installed"
    fi
    
    # Install zsh-syntax-highlighting
    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"; then
            print_module_status "✅ zsh-syntax-highlighting installed"
        else
            print_module_warning "Failed to install zsh-syntax-highlighting"
        fi
    else
        print_module_status "✅ zsh-syntax-highlighting already installed"
    fi
}

# ============================================================================
# Zsh Configuration Functions
# ============================================================================

create_zsh_config() {
    print_module_status "Creating enhanced Zsh configuration..."
    
    # Backup existing .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.42backup"
        print_module_status "Backed up existing .zshrc"
    fi
    
    # Create comprehensive .zshrc
    cat > "$HOME/.zshrc" << 'EOF'
# 42 École Zsh Configuration
# Enhanced setup for École 42 students

# ============================================================================
# Oh My Zsh Configuration
# ============================================================================

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  sudo
  history-substring-search
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# Environment Variables
# ============================================================================

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Better less
export LESS='-R -i -w -M -z-4'

# Language settings
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Terminal colors
export TERM=xterm-256color
export COLORTERM=truecolor

# 42 School specific paths (if they exist)
if [ -d "/sgoinfre" ]; then
    export PATH="/sgoinfre/bin:$PATH"
fi

# Add local bin to PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# ============================================================================
# History Configuration
# ============================================================================

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# History options
setopt EXTENDED_HISTORY          # Write timestamp to history
setopt INC_APPEND_HISTORY        # Write to history immediately
setopt SHARE_HISTORY             # Share history between sessions
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicates
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_VERIFY               # Show command before executing from history

# ============================================================================
# Directory Navigation
# ============================================================================

setopt AUTO_CD                   # cd by typing directory name
setopt AUTO_PUSHD                # Push directories to stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack

# ============================================================================
# Completion Options
# ============================================================================

setopt COMPLETE_ALIASES          # Complete aliases
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt AUTO_MENU                 # Show completion menu
setopt AUTO_LIST                 # List choices on ambiguous completion

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu selection
zstyle ':completion:*' menu select

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Group matches and describe groups
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m-- %d --\e[0m'

# ============================================================================
# Key Bindings
# ============================================================================

# History search with arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Ctrl+R for history search
bindkey '^R' history-incremental-search-backward

# Alt+. to insert last argument
bindkey '\e.' insert-last-word

# Ctrl+U to delete line
bindkey '^U' kill-whole-line

# Ctrl+W to delete word
bindkey '^W' backward-kill-word

# Home and End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# ============================================================================
# Color Configuration
# ============================================================================

# Set LS_COLORS for better file listing with Catppuccin colors
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32"

# Configure terminal colors if supported
if [[ "$TERM" == "xterm-256color" ]] || [[ "$TERM" == "screen-256color" ]] || [[ "$COLORTERM" == "truecolor" ]]; then
    # Export terminal color variables for applications that support them
    export TERM_COLOR_BACKGROUND="#1e1e2e"
    export TERM_COLOR_FOREGROUND="#cdd6f4"
    export TERM_COLOR_CURSOR="#f5e0dc"
fi

# ============================================================================
# 42 Specific Functions
# ============================================================================

# Quick project setup
42new() {
    if [ -z "$1" ]; then
        echo "Usage: 42new <project_name>"
        return 1
    fi
    
    local project_dir="$HOME/code/42/$1"
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Create basic Makefile if it doesn't exist
    if [ ! -f Makefile ]; then
        cat > Makefile << EOF
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: \$USER <\$USER@student.42.fr>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: $(date '+%Y/%m/%d %H:%M:%S') by \$USER           #+#    #+#              #
#    Updated: $(date '+%Y/%m/%d %H:%M:%S') by \$USER          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = $1

CC = gcc
CFLAGS = -Wall -Wextra -Werror
SRCDIR = src
OBJDIR = obj
INCDIR = inc

SRCS = \$(wildcard \$(SRCDIR)/*.c)
OBJS = \$(SRCS:\$(SRCDIR)/%.c=\$(OBJDIR)/%.o)

all: \$(NAME)

\$(NAME): \$(OBJS)
	\$(CC) \$(CFLAGS) -o \$@ \$^

\$(OBJDIR)/%.o: \$(SRCDIR)/%.c
	@mkdir -p \$(OBJDIR)
	\$(CC) \$(CFLAGS) -I\$(INCDIR) -c \$< -o \$@

clean:
	rm -rf \$(OBJDIR)

fclean: clean
	rm -f \$(NAME)

re: fclean all

.PHONY: all clean fclean re
EOF
    fi
    
    # Create directory structure
    mkdir -p src inc obj
    echo "✅ Created 42 project: $1"
    echo "📁 Directory: $project_dir"
    ls -la
}

# Quick compilation and test
ctest() {
    if [ ! -f "$1" ]; then
        echo "❌ File $1 not found!"
        return 1
    fi
    
    local filename="${1%.*}"
    local output="${filename}_test"
    
    echo "🔨 Compiling $1..."
    if gcc -Wall -Wextra -Werror -g -o "$output" "$1"; then
        echo "✅ Compilation successful!"
        echo "🚀 Running $output..."
        ./"$output"
        echo "🧹 Cleaning up..."
        rm -f "$output"
    else
        echo "❌ Compilation failed!"
        return 1
    fi
}

# Norminette check with better output
normcheck() {
    if command -v norminette >/dev/null 2>&1; then
        echo "📏 Running norminette..."
        if [ -z "$1" ]; then
            norminette .
        else
            norminette "$1"
        fi
    else
        echo "❌ Norminette not installed!"
        echo "💡 Install it from: https://github.com/42School/norminette"
    fi
}

# Git commit with automatic add
gcom() {
    if [ -z "$1" ]; then
        echo "Usage: gcom <commit_message>"
        return 1
    fi
    
    git add -A
    git commit -m "$1"
}

# Git add, commit, and push in one command
gacp() {
    if [ -z "$1" ]; then
        echo "Usage: gacp <commit_message>"
        return 1
    fi
    
    git add -A
    git commit -m "$1"
    git push
}

# Quick backup of current directory
backup_project() {
    local backup_name="backup_$(basename $PWD)_$(date +%Y%m%d_%H%M).tar.gz"
    tar -czf "../$backup_name" .
    echo "✅ Backup created: ../$backup_name"
}

# Utility function for directory creation and navigation
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ============================================================================
# 42 Productivity Aliases
# ============================================================================

# Navigation shortcuts
alias 42='cd ~/code/42'
alias code='cd ~/code'
alias tmp='cd ~/code/tmp'
alias reload='source ~/.zshrc'

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
alias ....='cd ../../..'

# Navigation shortcuts for directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# ============================================================================
# Load Additional Configurations
# ============================================================================

# Load 42 aliases if they exist
[ -f ~/.42_aliases ] && source ~/.42_aliases

# Load terminal environment if available
[ -f ~/.42_terminal_env ] && source ~/.42_terminal_env

# Load any local customizations
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ============================================================================
# Welcome Message
# ============================================================================

# Show a welcome message on new shell (only in interactive mode)
if [[ $- == *i* ]]; then
    echo ""
    echo "🎓 Welcome to 42 École Enhanced Zsh Environment!"
    echo "💡 Quick commands: 42 | code | norm | cc | gs"
    echo "🔧 Type '42new <project>' to create a new project"
    echo "📝 Note: You're in Zsh. Type 'exit' to return to bash."
    echo "📚 Cheatsheet: cat ~/.zsh-42-cheatsheet.md"
    echo ""
fi
EOF
    
    print_module_status "✅ Enhanced .zshrc created"
}

create_bash_integration() {
    print_module_status "Setting up bash integration..."
    
    # Create aliases for bash users
    local bash_config="
# 42 École Environment - Bash Integration
# Load 42 aliases and functions

# Source 42 aliases if they exist
[ -f ~/.42_aliases ] && source ~/.42_aliases

# Source terminal environment if available
[ -f ~/.42_terminal_env ] && source ~/.42_terminal_env

# 42-specific aliases for bash
alias 42='cd ~/code/42'
alias code='cd ~/code'
alias tmp='cd ~/code/tmp'
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

# Utility shortcuts
alias ll='ls -la'
alias la='ls -A'
alias reload='source ~/.bashrc'

# Function to start zsh easily
zsh42() {
    echo '🚀 Starting enhanced Zsh environment...'
    zsh
}

# Quick project creation (bash version)
42new() {
    if [ -z \"\$1\" ]; then
        echo \"Usage: 42new <project_name>\"
        return 1
    fi
    
    local project_dir=\"\$HOME/code/42/\$1\"
    mkdir -p \"\$project_dir\"
    cd \"\$project_dir\"
    echo \"✅ Created 42 project: \$1\"
}
"
    
    # Add to .bashrc if not already present
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "42 École Environment - Bash Integration" "$HOME/.bashrc"; then
            echo "$bash_config" >> "$HOME/.bashrc"
            print_module_status "Added bash integration to .bashrc"
        fi
    else
        echo "$bash_config" > "$HOME/.bashrc"
        print_module_status "Created .bashrc with bash integration"
    fi
}

create_zsh_cheatsheet() {
    print_module_status "Creating Zsh cheatsheet..."
    
    cat > "$HOME/.zsh-42-cheatsheet.md" << 'EOF'
# 42 École Zsh Cheatsheet

## Activation
- `zsh` - Start enhanced Zsh environment
- `exit` - Return to bash
- `zsh42` - Quick start from bash (alias)

## Navigation
- `42` - Go to ~/code/42
- `code` - Go to ~/code
- `tmp` - Go to ~/code/tmp
- `..` / `...` / `....` - Go up 1/2/3 directories
- `d` - Show directory stack
- `1-9` - Jump to directory by stack number

## 42 Project Functions
- `42new <name>` - Create new 42 project with Makefile
- `ctest file.c` - Compile, run, and cleanup
- `normcheck [file]` - Run norminette
- `backup_project` - Create tar.gz backup

## Development
- `cc file.c` - Compile with 42 flags
- `ccg file.c` - Compile with debug symbols
- `norm file.c` - Check norminette
- `valg ./program` - Run with valgrind

## Git Shortcuts
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git pull
- `glog` - Pretty git log
- `gcom "msg"` - Add all + commit
- `gacp "msg"` - Add all + commit + push
- `gundo` - Undo last commit

## History & Search
- `Ctrl+R` - Search history
- `↑/↓` - History substring search
- `Ctrl+P/N` - Previous/next in history
- `Alt+.` - Insert last argument

## Utilities
- `ll` - Detailed file list
- `la` - Show hidden files
- `mkcd <dir>` - Create and enter directory
- `reload` - Reload .zshrc

## Oh My Zsh Features
- **Autosuggestions**: Gray text appears as you type
- **Syntax highlighting**: Commands turn green/red
- **Tab completion**: Smart context-aware completion
- **Directory jumping**: `z <partial_name>` (after visiting)

## Key Bindings
- `Ctrl+A/E` - Beginning/end of line
- `Ctrl+U` - Delete entire line
- `Ctrl+W` - Delete word backward
- `Alt+.` - Insert last argument
- `Home/End` - Beginning/end of line

## History Configuration
- 100,000 commands stored
- Timestamps included
- Shared between sessions
- Duplicate removal
- Commands starting with space ignored

## Tips
1. Start typing and press `Tab` for completions
2. Use `z <directory>` to jump to frequently visited dirs
3. History is shared between all Zsh sessions
4. Commands starting with space won't be saved to history
5. Use `!!` to repeat last command
6. Use `!$` to get last argument of previous command
EOF
    
    print_module_status "✅ Cheatsheet saved to ~/.zsh-42-cheatsheet.md"
}

# ============================================================================
# Verification Functions
# ============================================================================

verify_zsh_setup() {
    print_module_status "Verifying Zsh setup..."
    
    local issues=()
    
    # Check if Zsh is available
    if command -v zsh >/dev/null 2>&1; then
        print_module_status "✅ Shell: Zsh available"
    else
        issues+=("Zsh not available")
    fi
    
    # Check if Oh My Zsh is installed
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_module_status "✅ Framework: Oh My Zsh installed"
    else
        issues+=("Oh My Zsh not installed")
    fi
    
    # Check if plugins are installed
    local plugins_ok=0
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        ((plugins_ok++))
    fi
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        ((plugins_ok++))
    fi
    
    if [[ $plugins_ok -eq 2 ]]; then
        print_module_status "✅ Plugins: All plugins installed"
    else
        issues+=("$((2-plugins_ok)) plugins missing")
    fi
    
    # Check if .zshrc exists
    if [[ -f "$HOME/.zshrc" ]]; then
        print_module_status "✅ Configuration: .zshrc found"
    else
        issues+=(".zshrc not found")
    fi
    
    # Test Zsh basic functionality
    if command -v zsh >/dev/null 2>&1; then
        if zsh -c "echo 'test'" >/dev/null 2>&1; then
            print_module_status "✅ Functionality: Zsh loads correctly"
        else
            issues+=("Zsh has loading issues")
        fi
    fi
    
    # Report results
    if [[ ${#issues[@]} -eq 0 ]]; then
        print_module_status "✅ Zsh setup verification passed"
        return 0
    else
        print_module_warning "Zsh setup has issues:"
        for issue in "${issues[@]}"; do
            print_module_warning "  - $issue"
        done
        return 1
    fi
}

# ============================================================================
# Main Zsh Setup Function
# ============================================================================

main() {
    print_module_status "🐚 Starting Zsh configuration..."
    
    local errors=0
    
    # Install Oh My Zsh
    if ! install_oh_my_zsh; then
        ((errors++))
    fi
    
    # Install plugins
    if ! install_zsh_plugins; then
        ((errors++))
    fi
    
    # Create Zsh configuration
    create_zsh_config
    
    # Create bash integration
    create_bash_integration
    
    # Create cheatsheet
    create_zsh_cheatsheet
    
    # Verify setup
    if ! verify_zsh_setup; then
        ((errors++))
    fi
    
    # Summary
    if [[ $errors -eq 0 ]]; then
        print_module_status "🎉 Zsh module completed successfully!"
        print_module_status "💡 Type 'zsh' to start enhanced shell"
        print_module_status "📚 Cheatsheet: ~/.zsh-42-cheatsheet.md"
    else
        print_module_warning "Zsh module completed with $errors issue(s)"
        print_module_status "Zsh functionality may be limited"
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