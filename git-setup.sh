#!/bin/bash

# Git Configuration Script for 42 École
# Usage: ./git-setup.sh

echo "🔧 Git Configuration for 42 École"
echo "================================="

# Check if git is available
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git is not installed!"
    exit 1
fi

# Get user information
echo "Please enter your information:"
read -p "Enter your full name: " USER_NAME
read -p "Enter your 42 email (e.g., username@student.42paris.fr): " USER_EMAIL

# Validate email format
if [[ ! "$USER_EMAIL" =~ @student\.42.*\.fr$ ]]; then
    echo "⚠️  Warning: Email doesn't match 42 format (@student.42city.fr)"
    read -p "Continue anyway? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Exiting..."
        exit 1
    fi
fi

echo ""
echo "📋 Configuration Details:"
echo "  Name: $USER_NAME"
echo "  Email: $USER_EMAIL"
echo ""

# Configure Git
echo ""
echo "⚙️  Configuring Git..."

if ! git config --global user.name "$USER_NAME"; then
    echo "❌ Failed to set git user.name"
    exit 1
fi

if ! git config --global user.email "$USER_EMAIL"; then
    echo "❌ Failed to set git user.email"
    exit 1
fi

git config --global core.editor vim
git config --global init.defaultBranch main
git config --global pull.rebase false

# Add useful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.lg "log --oneline --graph --all"
git config --global alias.undo "reset --soft HEAD~1"

echo "✅ Git configured successfully!"
echo ""
echo "📋 Configuration Summary:"
echo "  Name: $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"
echo "  Editor: $(git config --global core.editor)"
echo ""

# SSH Key Generation
echo "🔑 SSH Key Setup for GitHub:"
read -p "Generate SSH key? (Y/n): " generate_ssh

if [[ ! $generate_ssh =~ ^[Nn]$ ]]; then
    if [ -f ~/.ssh/id_ed25519 ]; then
        echo "⚠️  SSH key already exists"
        echo "📋 Your existing public key:"
        cat ~/.ssh/id_ed25519.pub
        echo ""
        echo "👆 Add this to GitHub: https://github.com/settings/ssh/new"
    else
        echo "Generating SSH key..."
        if ssh-keygen -t ed25519 -C "$USER_EMAIL" -f ~/.ssh/id_ed25519 -N ""; then
            # Set proper permissions
            chmod 700 ~/.ssh
            chmod 600 ~/.ssh/id_ed25519
            chmod 644 ~/.ssh/id_ed25519.pub
        else
            echo "❌ Failed to generate SSH key"
            exit 1
        fi
        
        echo ""
        echo "✅ SSH key generated!"
        echo "📋 Your public key:"
        echo "----------------------------------------"
        cat ~/.ssh/id_ed25519.pub
        echo "----------------------------------------"
    fi
    
    echo ""
    echo "📌 Next steps:"
    echo "1. Copy the key above"
    echo "2. Go to: https://github.com/settings/ssh/new"
    echo "3. Add key with title: '42-Paris-$(date +%Y)'"
    echo "4. Test with: ssh -T git@github.com"
fi

echo ""
echo "🎉 Git setup complete for 42 École!"
