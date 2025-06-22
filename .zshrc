# 42 École Zsh Configuration
# Additions to be appended to existing .zshrc

# ============================================================================
# Oh My Zsh Configuration
# ============================================================================

# Theme
ZSH_THEME="robbyrussell"

# ============================================================================
# Terminal Colors - Catppuccin Mocha
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

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  sudo
  history-substring-search
)

# ============================================================================
# History Configuration
# ============================================================================

HISTSIZE=50000
SAVEHIST=50000
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

# 42 School specific paths (if they exist)
if [ -d "/sgoinfre" ]; then
    export PATH="/sgoinfre/bin:$PATH"
fi

# Add local bin to PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

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

# ============================================================================
# 42 Productivity Aliases
# ============================================================================

# Navigation shortcuts for directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# ============================================================================
# Load Additional Configurations
# ============================================================================

# Load 42 aliases if they exist
[ -f ~/.42_aliases ] && source ~/.42_aliases

# Load any local customizations
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ============================================================================
# Font Configuration
# ============================================================================

# Set font for terminal applications that support it
export TERM_FONT="JetBrainsMono Nerd Font"
export TERM_FONT_SIZE="11"

# Function to configure terminal font (works with some terminals)
configure_terminal_font() {
    # For GNOME Terminal
    if command -v gsettings >/dev/null 2>&1; then
        # Try to set font in current profile
        local profile=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
        if [ -n "$profile" ]; then
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ font 'JetBrainsMono Nerd Font 11' 2>/dev/null || true
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-system-font false 2>/dev/null || true
        fi
    fi
    
    # For Tilix
    if command -v dconf >/dev/null 2>&1; then
        dconf write /com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/font "'JetBrainsMono Nerd Font 11'" 2>/dev/null || true
    fi
}

# ============================================================================
# Welcome Message
# ============================================================================

# Show a welcome message on new shell (only in interactive mode)
if [[ $- == *i* ]]; then
    echo "🎓 Welcome to 42 environment!"
    echo "💡 Quick commands: 42 | code | norm | cc | gs"
    echo "🔧 Type '42new <project>' to create a new project"
fi
