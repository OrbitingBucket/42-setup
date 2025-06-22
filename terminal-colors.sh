#!/bin/bash

# 42 Terminal Colors Setup
# Sets up Catppuccin Mocha color scheme for GNOME Terminal

echo "🎨 Setting up terminal colors..."

# Check if we're on GNOME
if ! command -v gnome-terminal &> /dev/null; then
    echo "⚠️  GNOME Terminal not found. This script is for GNOME Terminal."
    exit 1
fi

# Create new GNOME Terminal profile
PROFILE_NAME="42-Catppuccin"
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default)
PROFILE_ID=${PROFILE_ID:1:-1} # Remove quotes

# Create new profile
dconf dump /org/gnome/terminal/legacy/profiles:/ > /tmp/gnome-terminal-profiles.dconf
NEW_PROFILE_ID=$(uuidgen)

# Catppuccin Mocha colors
BACKGROUND="#1e1e2e"
FOREGROUND="#cdd6f4"
# ANSI colors mapping:
# 0: Black (Surface1), 1: Red, 2: Green, 3: Yellow, 4: Blue, 5: Magenta (Pink), 6: Cyan (Teal), 7: White (Subtext1)
# 8: Bright Black (Surface2), 9: Bright Red (Peach), 10: Bright Green, 11: Bright Yellow, 12: Bright Blue (Sky), 13: Bright Magenta (Mauve), 14: Bright Cyan, 15: Bright White (Text)
PALETTE="['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#bac2de', '#585b70', '#fab387', '#a6e3a1', '#f9e2af', '#89dceb', '#cba6f7', '#94e2d5', '#cdd6f4']"

# Apply colors to current profile
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ background-color "$BACKGROUND"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ foreground-color "$FOREGROUND"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ palette "$PALETTE"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-theme-transparency false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ font 'JetBrainsMono Nerd Font 12'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-system-font false

# Set profile name
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ visible-name "$PROFILE_NAME"

echo "✅ Terminal colors applied!"
echo "🔄 Close and reopen terminal to see changes"
echo "📝 Profile: $PROFILE_NAME"
echo ""
echo "🎨 Manual setup (if script doesn't work):"
echo "1. Open Terminal Preferences"
echo "2. Create new profile: $PROFILE_NAME"
echo "3. Colors tab:"
echo "   - Background: $BACKGROUND"
echo "   - Foreground: $FOREGROUND"
echo "   - Use theme colors: OFF"
echo "4. Set font: JetBrainsMono Nerd Font 12"