#!/bin/bash

# 42 École Bash Configuration Module
# Sets up bash with optimized settings for École 42
# No admin rights required

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[BASH]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[BASH]${NC} $1"
}

print_error() {
    echo -e "${RED}[BASH]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[BASH]${NC} $1"
}

install_dependencies() {
    print_step "Installing bash dependencies..."
    
    # Create local directories
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    
    # Install fasd for fast directory jumping (if not installed)
    if ! command -v fasd >/dev/null 2>&1; then
        print_step "Installing fasd for fast directory navigation..."
        
        # Download and install fasd to local bin
        curl -sSL https://raw.githubusercontent.com/clvv/fasd/master/fasd -o "$HOME/.local/bin/fasd"
        chmod +x "$HOME/.local/bin/fasd"
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
        fi
        
        print_status "✅ fasd installed to ~/.local/bin/fasd"
    else
        print_status "✅ fasd already available"
    fi
    
    # Install ripgrep for better searching (if available via package manager)
    if ! command -v rg >/dev/null 2>&1; then
        print_warning "ripgrep (rg) not found - grep fallback will be used"
    else
        print_status "✅ ripgrep available for enhanced searching"
    fi
}

setup_bash_configuration() {
    print_step "Setting up bash configuration..."
    
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local bashrc_source="$script_dir/configs/.bashrc"
    
    # Check if source bashrc exists
    if [[ ! -f "$bashrc_source" ]]; then
        print_error "Source .bashrc not found at $bashrc_source"
        return 1
    fi
    
    # Copy the optimized bashrc
    cp "$bashrc_source" "$HOME/.bashrc"
    print_status "✅ Installed optimized .bashrc"
    
    # Ensure local bin is in PATH
    if ! grep -q '$HOME/.local/bin' "$HOME/.bashrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        print_status "✅ Added ~/.local/bin to PATH"
    fi
    
    # Source the new configuration
    set +e  # Don't exit on error for sourcing
    source "$HOME/.bashrc" 2>/dev/null || true
    set -e
    
    print_status "✅ Bash configuration applied"
}

setup_42_aliases() {
    print_step "Setting up 42 École specific aliases and functions..."
    
    # Create 42-specific aliases file
    cat > "$HOME/.42_aliases" << 'EOF'
# 42 École Specific Aliases and Functions
# Source this from your .bashrc

# Directory navigation for 42 projects
alias 42='cd ~/code/42'
alias code='cd ~/code'
alias tmp='cd ~/code/tmp'
alias personal='cd ~/code/personal'

# Compilation aliases with 42 flags
alias cc='gcc -Wall -Wextra -Werror'
alias ccg='gcc -Wall -Wextra -Werror -g'  # With debug symbols
alias ccf='gcc -Wall -Wextra -Werror -fsanitize=address -g'  # With AddressSanitizer

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'
alias gundo='git reset --soft HEAD~1'

# Utility aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias h='history'
alias j='jobs -l'
alias ..='cd ..'
alias ...='cd ../..'

# 42 École Functions

# Create new 42 project with basic structure
42new() {
    if [[ -z "$1" ]]; then
        echo "Usage: 42new <project_name>"
        return 1
    fi
    
    local project_name="$1"
    local project_dir="$HOME/code/42/$project_name"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Create basic Makefile
    cat > Makefile << 'MAKEFILE_EOF'
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: login <login@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: $(date +"%Y/%m/%d %H:%M:%S") by login             #+#    #+#              #
#    Updated: $(date +"%Y/%m/%d %H:%M:%S") by login            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = $(PROJECT_NAME)

SRCS = main.c

OBJS = $(SRCS:.c=.o)

CC = gcc
CFLAGS = -Wall -Wextra -Werror

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) -o $(NAME) $(OBJS)

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
MAKEFILE_EOF
    
    # Replace PROJECT_NAME in Makefile
    sed -i "s/\$(PROJECT_NAME)/$project_name/g" Makefile
    
    # Create basic main.c
    cat > main.c << 'MAIN_EOF'
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: login <login@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: $(date +"%Y/%m/%d %H:%M:%S") by login             #+#    #+#             */
/*   Updated: $(date +"%Y/%m/%d %H:%M:%S") by login            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    printf("Hello, 42!\n");
    return (0);
}
MAIN_EOF
    
    echo "✅ Created 42 project: $project_dir"
    echo "📁 Files created: Makefile, main.c"
}

# Quick compile and test function
ctest() {
    if [[ -z "$1" ]]; then
        echo "Usage: ctest <file.c>"
        return 1
    fi
    
    local file="$1"
    local name="${file%.c}"
    
    echo "🔨 Compiling $file..."
    if gcc -Wall -Wextra -Werror -o "$name" "$file"; then
        echo "✅ Compilation successful"
        echo "🚀 Running ./$name"
        "./$name"
        echo ""
        echo "🧹 Cleaning up..."
        rm -f "$name"
    else
        echo "❌ Compilation failed"
        return 1
    fi
}

# Enhanced norminette function (if norminette is available)
normcheck() {
    if command -v norminette >/dev/null 2>&1; then
        if [[ -n "$1" ]]; then
            norminette "$1"
        else
            norminette *.c *.h 2>/dev/null || echo "No .c or .h files found"
        fi
    else
        echo "⚠️  norminette not installed"
        echo "🔍 Basic style check:"
        
        # Basic checks
        if [[ -n "$1" ]]; then
            local files=("$1")
        else
            local files=(*.c *.h)
        fi
        
        for file in "${files[@]}"; do
            if [[ -f "$file" ]]; then
                echo "Checking $file:"
                
                # Check line length
                local long_lines=$(awk 'length > 80 {print NR ": " $0}' "$file")
                if [[ -n "$long_lines" ]]; then
                    echo "  ❌ Lines over 80 characters:"
                    echo "$long_lines"
                fi
                
                # Check trailing whitespace
                local trailing_ws=$(grep -n '[[:space:]]$' "$file" || true)
                if [[ -n "$trailing_ws" ]]; then
                    echo "  ❌ Trailing whitespace found:"
                    echo "$trailing_ws"
                fi
                
                # Check for tabs (should not be expanded in 42)
                if ! grep -q $'\t' "$file"; then
                    echo "  ⚠️  No tabs found (École 42 uses tabs, not spaces)"
                fi
                
                echo ""
            fi
        done
    fi
}

# Git workflow functions
gcom() {
    if [[ -z "$1" ]]; then
        echo "Usage: gcom \"commit message\""
        return 1
    fi
    
    git add .
    git commit -m "$1"
}

gacp() {
    if [[ -z "$1" ]]; then
        echo "Usage: gacp \"commit message\""
        return 1
    fi
    
    git add .
    git commit -m "$1"
    git push
}

# Utility functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

backup() {
    local backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir "$backup_dir"
    cp -r ./* "$backup_dir/" 2>/dev/null || true
    echo "✅ Backup created: $backup_dir"
}

reload() {
    source ~/.bashrc
    echo "✅ Bash configuration reloaded"
}

# Valgrind shortcut
valg() {
    if command -v valgrind >/dev/null 2>&1; then
        valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes "$@"
    else
        echo "⚠️  valgrind not installed"
        "$@"
    fi
}

# Display helpful information
42help() {
    echo "🎓 42 École Bash Commands:"
    echo ""
    echo "📁 Navigation:"
    echo "  42          - Go to ~/code/42"
    echo "  code        - Go to ~/code"
    echo "  tmp         - Go to ~/code/tmp"
    echo ""
    echo "🔨 Development:"
    echo "  cc file.c   - Compile with 42 flags"
    echo "  ctest file.c - Quick compile and test"
    echo "  42new name  - Create new 42 project"
    echo "  normcheck   - Check norminette compliance"
    echo ""
    echo "📦 Git:"
    echo "  gs          - git status"
    echo "  gcom \"msg\"  - git add all + commit"
    echo "  gacp \"msg\"  - git add all + commit + push"
    echo ""
    echo "🛠️  Utilities:"
    echo "  mkcd dir    - Create directory and cd into it"
    echo "  backup      - Backup current directory"
    echo "  reload      - Reload bash configuration"
    echo "  valg prog   - Run program with valgrind"
}

EOF

    # Add sourcing to .bashrc if not already there
    if ! grep -q '.42_aliases' "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# Source 42 École specific aliases and functions" >> "$HOME/.bashrc"
        echo "if [ -f ~/.42_aliases ]; then" >> "$HOME/.bashrc"
        echo "    . ~/.42_aliases" >> "$HOME/.bashrc"
        echo "fi" >> "$HOME/.bashrc"
        print_status "✅ Added 42 aliases sourcing to .bashrc"
    fi
    
    print_status "✅ 42 École aliases and functions installed"
}

setup_history_configuration() {
    print_step "Optimizing bash history configuration..."
    
    # Check if history settings are already optimized
    if ! grep -q "HISTSIZE=100000" "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'

# Enhanced history configuration for École 42
export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
shopt -s histappend
shopt -s cmdhist

EOF
        print_status "✅ Enhanced history configuration added"
    else
        print_status "✅ History configuration already optimized"
    fi
}

verify_bash_setup() {
    print_step "Verifying bash setup..."
    
    local issues=0
    
    # Check if .bashrc exists and is readable
    if [[ ! -r "$HOME/.bashrc" ]]; then
        print_error "❌ .bashrc not readable"
        issues=$((issues + 1))
    else
        print_status "✅ .bashrc is readable"
    fi
    
    # Check if 42 aliases are available
    if [[ -f "$HOME/.42_aliases" ]]; then
        print_status "✅ 42 aliases file exists"
    else
        print_error "❌ 42 aliases file missing"
        issues=$((issues + 1))
    fi
    
    # Check if fasd is available
    if command -v fasd >/dev/null 2>&1; then
        print_status "✅ fasd available for fast navigation"
    else
        print_warning "⚠️  fasd not available (directory jumping will be limited)"
    fi
    
    # Check directory structure
    for dir in "$HOME/code/42" "$HOME/code/personal" "$HOME/code/tmp"; do
        if [[ -d "$dir" ]]; then
            print_status "✅ Directory exists: $dir"
        else
            print_warning "⚠️  Directory missing: $dir (will be created on first use)"
        fi
    done
    
    if [[ $issues -eq 0 ]]; then
        print_status "🎉 Bash setup verification passed!"
        return 0
    else
        print_error "❌ Bash setup has $issues issues"
        return 1
    fi
}

show_completion_message() {
    echo ""
    echo -e "${CYAN}🎓 Bash Configuration Complete!${NC}"
    echo -e "${CYAN}================================${NC}"
    echo ""
    echo -e "${GREEN}✅ What's been configured:${NC}"
    echo "   • Optimized .bashrc with École 42 settings"
    echo "   • Fast directory navigation with fasd"
    echo "   • 42-specific aliases and functions"
    echo "   • Enhanced history configuration"
    echo "   • Git workflow shortcuts"
    echo "   • Project creation tools"
    echo ""
    echo -e "${BLUE}🚀 Quick Start:${NC}"
    echo "   source ~/.bashrc          # Reload configuration"
    echo "   42help                    # Show all available commands"
    echo "   42new myproject          # Create new 42 project"
    echo "   42                       # Go to projects directory"
    echo ""
    echo -e "${YELLOW}💡 Key Features:${NC}"
    echo "   • Type '42help' for a full command reference"
    echo "   • Use 'j <partial_name>' for fast directory jumping"
    echo "   • All compilation uses 42 flags automatically"
    echo ""
}

main() {
    echo -e "${BLUE}🐚 Setting up Bash for École 42...${NC}"
    echo ""
    
    install_dependencies
    setup_bash_configuration
    setup_42_aliases
    setup_history_configuration
    
    if verify_bash_setup; then
        show_completion_message
        echo -e "${GREEN}To activate the new configuration, run: source ~/.bashrc${NC}"
        return 0
    else
        print_error "Setup completed with issues. Check the log above."
        return 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi