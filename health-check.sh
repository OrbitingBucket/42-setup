#!/bin/bash

# 42 Environment Health Check
# Usage: curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🔍 42 Environment Health Check${NC}"
echo "=================================="

issues=0

# Function to check and report
check_item() {
    local description="$1"
    local command="$2"
    local status_type="${3:-required}"  # required, optional, info
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "✅ $description"
        return 0
    else
        if [ "$status_type" = "required" ]; then
            echo -e "❌ $description"
            ((issues++))
            return 1
        elif [ "$status_type" = "optional" ]; then
            echo -e "⚠️  $description"
            return 1
        else
            echo -e "ℹ️  $description"
            return 1
        fi
    fi
}

# System Information
echo ""
echo "🖥️  System Information:"
echo "   User: $(whoami)"
echo "   Hostname: $(hostname)"
echo "   PWD: $(pwd)"
echo "   Shell: $SHELL"
echo "   Home: $HOME"

# Git Configuration
echo ""
echo "📝 Git Configuration:"
if git config --global user.name >/dev/null 2>&1; then
    echo "   ✅ Name: $(git config --global user.name)"
    echo "   ✅ Email: $(git config --global user.email)"
    echo "   ✅ Editor: $(git config --global core.editor)"
    
    # Test git aliases
    if git config --global alias.st >/dev/null 2>&1; then
        echo "   ✅ Custom aliases configured"
    else
        echo "   ❌ Git aliases missing"
        ((issues++))
    fi
    
    # Check if email is 42 format
    local git_email=$(git config --global user.email)
    if [[ "$git_email" =~ @student\.42.*\.fr$ ]]; then
        echo "   ✅ Using 42 email format"
    else
        echo "   ⚠️  Not using 42 email format (current: $git_email)"
    fi
else
    echo "   ❌ Git not configured"
    echo "   💡 Run: curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/git-setup.sh | bash"
    ((issues++))
fi

# Development Tools
echo ""
echo "🛠️  Development Tools:"
check_item "GCC compiler" "command -v gcc"
check_item "Make build tool" "command -v make"
check_item "Git version control" "command -v git"
check_item "Vim editor" "command -v vim"
check_item "Curl download tool" "command -v curl"
check_item "Norminette (42 norm checker)" "command -v norminette" "optional"
check_item "Valgrind (memory checker)" "command -v valgrind" "optional"

# Check GCC flags
if command -v gcc >/dev/null 2>&1; then
    echo "   ℹ️  GCC version: $(gcc --version | head -1)"
    
    # Test compilation with 42 flags
    temp_file="/tmp/test_42_compile.c"
    echo '#include <stdio.h>
int main(void) { printf("Hello 42!\\n"); return 0; }' > "$temp_file"
    
    if gcc -Wall -Wextra -Werror -o /tmp/test_42_compile "$temp_file" 2>/dev/null; then
        echo "   ✅ 42 compilation flags working"
        rm -f /tmp/test_42_compile
    else
        echo "   ❌ 42 compilation flags not working"
        ((issues++))
    fi
    rm -f "$temp_file"
fi

# Shell Environment
echo ""
echo "🐚 Shell Environment:"
check_item "Zsh shell available" "command -v zsh" "optional"
check_item "Oh My Zsh installed" "[ -d ~/.oh-my-zsh ]" "optional"

if [ -d ~/.oh-my-zsh ]; then
    # Check plugins
    local plugins_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"
    check_item "Zsh autosuggestions plugin" "[ -d '$plugins_dir/zsh-autosuggestions' ]" "optional"
    check_item "Zsh syntax highlighting plugin" "[ -d '$plugins_dir/zsh-syntax-highlighting' ]" "optional"
fi

if [ -f ~/.42_aliases ]; then
    echo "   ✅ 42 aliases file exists"
    if grep -q "source ~/.42_aliases" ~/.bashrc 2>/dev/null || grep -q "source ~/.42_aliases" ~/.zshrc 2>/dev/null; then
        echo "   ✅ Aliases sourced in shell config"
    else
        echo "   ❌ Aliases not sourced in shell config"
        ((issues++))
    fi
else
    echo "   ❌ 42 aliases file missing"
    ((issues++))
fi

# Configuration Files
echo ""
echo "📄 Configuration Files:"
check_item "Vim configuration (~/.vimrc)" "[ -f ~/.vimrc ]"

if [ -f ~/.vimrc ]; then
    # Check for 42-specific configurations
    if grep -q "42" ~/.vimrc 2>/dev/null; then
        echo "   ✅ 42-specific vim configurations found"
    else
        echo "   ⚠️  No 42-specific configurations in .vimrc"
    fi
    
    # Check for line length highlighting
    if grep -q "ColorColumn" ~/.vimrc 2>/dev/null; then
        echo "   ✅ Line length highlighting configured (80 chars)"
    else
        echo "   ⚠️  No line length highlighting (norminette requirement)"
    fi
fi

check_item "Shell configuration" "[ -f ~/.bashrc ] || [ -f ~/.zshrc ]"

# Directory Structure
echo ""
echo "📁 Directory Structure:"
for dir in "~/code" "~/code/42" "~/code/personal" "~/code/tmp"; do
    expanded_dir=$(eval echo "$dir")
    check_item "$dir" "[ -d '$expanded_dir' ]"
done

# Test navigation aliases
echo ""
echo "🧪 Function Tests:"
if [ -f ~/.42_aliases ]; then
    source ~/.42_aliases 2>/dev/null
    
    # Test functions
    if type mkcd >/dev/null 2>&1; then
        echo "   ✅ mkcd function available"
    else
        echo "   ❌ mkcd function missing"
        ((issues++))
    fi
    
    if type backup >/dev/null 2>&1; then
        echo "   ✅ backup function available"
    else
        echo "   ❌ backup function missing"
        ((issues++))
    fi
    
    if type compile >/dev/null 2>&1; then
        echo "   ✅ compile function available"
    else
        echo "   ❌ compile function missing"
        ((issues++))
    fi
fi

# SSH Configuration
echo ""
echo "🔐 SSH Configuration:"
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "   ✅ SSH private key exists"
    echo "   ✅ SSH public key exists"
    echo "   📋 Key fingerprint: $(ssh-keygen -lf ~/.ssh/id_ed25519.pub | awk '{print $2}')"
    
    # Check permissions
    if [ "$(stat -c %a ~/.ssh 2>/dev/null)" = "700" ] && [ "$(stat -c %a ~/.ssh/id_ed25519 2>/dev/null)" = "600" ]; then
        echo "   ✅ SSH permissions correct"
    else
        echo "   ⚠️  SSH permissions may be incorrect"
    fi
    
    # Test GitHub connection
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" 2>/dev/null; then
        echo "   ✅ GitHub SSH connection working"
    else
        echo "   ⚠️  GitHub SSH not configured or not working"
        echo "   💡 Add your key to: https://github.com/settings/ssh/new"
    fi
else
    echo "   ⚠️  No SSH key found"
    echo "   💡 Generate with: ssh-keygen -t ed25519 -C \"youremail@student.42city.fr\""
fi

# Test Key Aliases
echo ""
echo "⚡ Quick Command Tests:"

# Test directory navigation
if [ -d ~/code/42 ]; then
    echo "   ✅ '42' command target exists (~/code/42)"
else
    echo "   ❌ '42' command target missing (~/code/42)"
    ((issues++))
fi

# Test compiler alias
if command -v gcc >/dev/null 2>&1; then
    echo "   ✅ 'cc' alias target exists (gcc with 42 flags)"
else
    echo "   ❌ 'cc' alias target missing (gcc)"
    ((issues++))
fi

# System Resources
echo ""
echo "💾 System Resources:"
echo "   ✅ Available space: $(df -h ~ | tail -1 | awk '{print $4}')"
echo "   ✅ Memory usage: $(free -h 2>/dev/null | grep '^Mem' | awk '{print $3"/"$2}' || echo 'N/A')"

# Test Vim
echo ""
echo "📝 Vim Tests:"
if command -v vim >/dev/null 2>&1; then
    if vim --version | grep -q "+termguicolors" 2>/dev/null; then
        echo "   ✅ Vim supports 24-bit colors"
    else
        echo "   ⚠️  Vim may not support 24-bit colors"
    fi
    
    # Test vim can start and exit
    if timeout 5s vim -c 'qa!' /dev/null 2>/dev/null; then
        echo "   ✅ Vim starts and exits correctly"
    else
        echo "   ⚠️  Vim may have configuration issues"
    fi
fi

# Final Summary
echo ""
echo "========================="
if [ $issues -eq 0 ]; then
    echo -e "${GREEN}🎉 HEALTH CHECK PASSED!${NC}"
    echo "✅ Your 42 environment is perfectly configured!"
    echo ""
    echo "🚀 Ready for:"
    echo "   • C programming projects"
    echo "   • Git version control with proper 42 email"
    echo "   • Norminette compliance"
    echo "   • Collaborative development"
    echo "   • Efficient coding workflow"
elif [ $issues -le 2 ]; then
    echo -e "${YELLOW}⚠️  MINOR ISSUES DETECTED${NC}"
    echo "🔧 $issues issue(s) found, but environment should work"
    echo "💡 Consider fixing the issues above for optimal experience"
else
    echo -e "${RED}❌ SETUP INCOMPLETE${NC}"
    echo "🔧 $issues issue(s) found - some functionality may not work"
    echo "💡 Please run the setup script again or fix issues manually"
fi
echo "========================="

# Provide helpful commands
echo ""
echo "📚 Useful commands to remember:"
echo "   42           # Go to projects directory"
echo "   42new <name> # Create new 42 project with Makefile"
echo "   cc file.c    # Compile with 42 flags"
echo "   ctest file.c # Compile and test quickly"
echo "   norm file.c  # Check code norm (alias for norminette)"
echo "   gs           # Git status"
echo "   gcom \"msg\"   # Git add all + commit"
echo "   mkcd newdir  # Create and enter directory"

echo ""
echo "🔗 Useful links:"
echo "   • Norminette: https://github.com/42School/norminette"
echo "   • 42 Intranet: https://intra.42.fr"
echo "   • GitHub SSH: https://github.com/settings/ssh/new"

exit $issues
