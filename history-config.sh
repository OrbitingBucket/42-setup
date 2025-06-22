#!/bin/bash

# 42 History Configuration Script
# Increases history size for both bash and zsh

echo "📚 Configuring shell history..."

# Bash History Configuration
BASHRC_HISTORY="
# 42 History Configuration for Bash
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%F %T '
export HISTIGNORE='ls:ll:cd:pwd:bg:fg:history:clear'

# Append to history file, don't overwrite
shopt -s histappend

# Update history after each command
export PROMPT_COMMAND=\"history -a; history -c; history -r; \$PROMPT_COMMAND\"
"

# Add to .bashrc if not already present
if ! grep -q "42 History Configuration for Bash" ~/.bashrc 2>/dev/null; then
    echo "$BASHRC_HISTORY" >> ~/.bashrc
    echo "✅ Added bash history configuration to ~/.bashrc"
else
    echo "ℹ️  Bash history configuration already exists"
fi

# For zsh, the configuration is already in .zshrc from the main setup
if [ -f ~/.zshrc ] && grep -q "HISTSIZE=100000" ~/.zshrc; then
    echo "✅ Zsh history already configured (100,000 entries)"
elif [ -f ~/.zshrc ]; then
    echo "⚠️  Zsh history needs updating - run the main setup script"
else
    echo "ℹ️  No zsh configuration found"
fi

echo "📊 History configuration complete!"
echo "💡 Restart your terminal or run 'source ~/.bashrc' to apply changes"