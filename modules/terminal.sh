#!/bin/bash

# 42 École Terminal Setup Module
# Configures terminal colors, fonts, and environment variables

# ============================================================================
# Configuration
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_module_status() { echo -e "${GREEN}[TERMINAL]${NC} $1"; }
print_module_warning() { echo -e "${YELLOW}[TERMINAL]${NC} $1"; }
print_module_error() { echo -e "${RED}[TERMINAL]${NC} $1"; }

# Font configuration
FONT_NAME="JetBrainsMono"
FONT_VERSION="v3.1.1"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/JetBrainsMono.zip"
FONT_DIR="$HOME/.local/share/fonts"

# Terminal color configuration (your working palette from home machine)
CATPPUCCIN_MOCHA_PALETTE="['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#a6adc8', '#585b70', '#f37799', '#89d88b', '#ebd391', '#74a8fc', '#f2aede', '#6bd7ca', '#bac2de']"
BACKGROUND_COLOR="#1e1e2e"
FOREGROUND_COLOR="#cdd6f4"

# ============================================================================
# Font Installation Functions
# ============================================================================

install_jetbrains_mono_font() {
    print_module_status "Installing JetBrains Mono Nerd Font..."
    
    # Create font directory
    mkdir -p "$FONT_DIR"
    
    # Check if font already exists
    if fc-list | grep -qi "jetbrainsmono"; then
        print_module_status "✅ JetBrains Mono Nerd Font already installed"
        return 0
    fi
    
    # Download and install font
    local temp_dir="/tmp/jetbrains_font_$$"
    local font_zip="/tmp/JetBrainsMono.zip"
    
    if command -v curl >/dev/null 2>&1; then
        print_module_status "Downloading ${FONT_NAME} Nerd Font..."
        if curl -L "$FONT_URL" -o "$font_zip"; then
            mkdir -p "$temp_dir"
            
            if command -v unzip >/dev/null 2>&1; then
                if unzip -q "$font_zip" -d "$temp_dir"; then
                    # Copy font files to user font directory
                    find "$temp_dir" -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
                    
                    # Update font cache if possible
                    if command -v fc-cache >/dev/null 2>&1; then
                        fc-cache -f "$FONT_DIR"
                        print_module_status "✅ Font cache updated"
                    fi
                    
                    print_module_status "✅ JetBrains Mono Nerd Font installed"
                    
                    # Cleanup
                    rm -rf "$temp_dir" "$font_zip"
                    return 0
                else
                    print_module_error "Failed to extract font archive"
                    rm -f "$font_zip"
                    return 1
                fi
            else
                print_module_warning "unzip not available, skipping font installation"
                rm -f "$font_zip"
                return 1
            fi
        else
            print_module_error "Failed to download font"
            return 1
        fi
    else
        print_module_warning "curl not available, skipping font installation"
        return 1
    fi
}

# ============================================================================
# Terminal Color Configuration Functions
# ============================================================================

configure_gnome_terminal_colors() {
    print_module_status "Configuring GNOME Terminal colors..."
    
    # Check if dconf is available (more reliable than checking desktop environment)
    if ! command -v dconf >/dev/null 2>&1; then
        print_module_warning "dconf not available, skipping GNOME Terminal configuration"
        return 1
    fi
    
    # Create a new Catppuccin Mocha profile
    local new_profile_id=$(uuidgen)
    local profile_path="/org/gnome/terminal/legacy/profiles:/:$new_profile_id/"
    
    print_module_status "Creating Catppuccin Mocha profile: $new_profile_id"
    
    # Set the profile configuration using dconf
    dconf write "$profile_path"background-color "'$BACKGROUND_COLOR'" 2>/dev/null || true
    dconf write "$profile_path"foreground-color "'$FOREGROUND_COLOR'" 2>/dev/null || true
    dconf write "$profile_path"palette "$CATPPUCCIN_MOCHA_PALETTE" 2>/dev/null || true
    dconf write "$profile_path"use-theme-colors false 2>/dev/null || true
    dconf write "$profile_path"use-system-font false 2>/dev/null || true
    dconf write "$profile_path"font "'JetBrainsMono Nerd Font 12'" 2>/dev/null || true
    dconf write "$profile_path"visible-name "'Catppuccin Mocha'" 2>/dev/null || true
    dconf write "$profile_path"bold-is-bright true 2>/dev/null || true
    dconf write "$profile_path"cursor-colors-set true 2>/dev/null || true
    dconf write "$profile_path"cursor-background-color "'#f5e0dc'" 2>/dev/null || true
    dconf write "$profile_path"cursor-foreground-color "'#1e1e2e'" 2>/dev/null || true
    dconf write "$profile_path"highlight-colors-set true 2>/dev/null || true
    dconf write "$profile_path"highlight-background-color "'#f5e0dc'" 2>/dev/null || true
    dconf write "$profile_path"highlight-foreground-color "'#585b70'" 2>/dev/null || true
    
    # Add the new profile to the profiles list
    local current_list=$(dconf read /org/gnome/terminal/legacy/profiles:/list 2>/dev/null || echo "[]")
    if [[ "$current_list" == "[]" ]] || [[ -z "$current_list" ]]; then
        dconf write /org/gnome/terminal/legacy/profiles:/list "['$new_profile_id']" 2>/dev/null || true
    else
        # Add to existing list
        local updated_list=$(echo "$current_list" | sed "s/\]/, '$new_profile_id']/")
        dconf write /org/gnome/terminal/legacy/profiles:/list "$updated_list" 2>/dev/null || true
    fi
    
    # Set as default profile
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$new_profile_id'" 2>/dev/null || true
    
    print_module_status "✅ GNOME Terminal Catppuccin Mocha profile created and set as default"
    print_module_status "💡 Restart terminal or open new tab to see changes"
    
    # Also try to configure existing profiles as fallback
    if command -v gsettings >/dev/null 2>&1; then
        local existing_profiles=$(gsettings get org.gnome.Terminal.ProfilesList list 2>/dev/null | tr -d "[]'," | tr ' ' '\n')
        
        for profile_id in $existing_profiles; do
            if [[ -n "$profile_id" ]]; then
                local profile_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/"
                
                # Apply colors to existing profile too
                gsettings set "$profile_path" background-color "'$BACKGROUND_COLOR'" 2>/dev/null || true
                gsettings set "$profile_path" foreground-color "'$FOREGROUND_COLOR'" 2>/dev/null || true
                gsettings set "$profile_path" palette "$CATPPUCCIN_MOCHA_PALETTE" 2>/dev/null || true
                gsettings set "$profile_path" use-theme-colors false 2>/dev/null || true
                gsettings set "$profile_path" font "'JetBrainsMono Nerd Font 12'" 2>/dev/null || true
                gsettings set "$profile_path" use-system-font false 2>/dev/null || true
            fi
        done
        
        print_module_status "✅ Updated existing terminal profiles"
    fi
    
    return 0
}

create_color_reference_file() {
    print_module_status "Creating color reference file..."
    
    cat > "$HOME/.catppuccin-mocha-reference.conf" << 'EOF'
# Catppuccin Mocha Color Reference
# For manual terminal configuration

[Colors]
background = #1e1e2e
foreground = #cdd6f4

# Normal colors (0-7)
color0  = #45475a  # Surface1 (Black)
color1  = #f38ba8  # Red
color2  = #a6e3a1  # Green  
color3  = #f9e2af  # Yellow
color4  = #89b4fa  # Blue
color5  = #f5c2e7  # Pink (Magenta)
color6  = #94e2d5  # Teal (Cyan)
color7  = #a6adc8  # Subtext0 (White)

# Bright colors (8-15)
color8  = #585b70  # Surface2 (Bright Black)
color9  = #f37799  # Bright Red
color10 = #89d88b  # Bright Green
color11 = #ebd391  # Bright Yellow
color12 = #74a8fc  # Bright Blue
color13 = #f2aede  # Bright Magenta
color14 = #6bd7ca  # Bright Cyan
color15 = #bac2de  # Subtext1 (Bright White)

[Font]
family = JetBrainsMono Nerd Font
size = 12

[Manual Configuration]
For other terminals, use the colors above.
GNOME Terminal palette string:
['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#a6adc8', '#585b70', '#f37799', '#89d88b', '#ebd391', '#74a8fc', '#f2aede', '#6bd7ca', '#bac2de']
EOF
    
    print_module_status "✅ Color reference saved to ~/.catppuccin-mocha-reference.conf"
}

# ============================================================================
# Environment Configuration Functions  
# ============================================================================

configure_terminal_environment() {
    print_module_status "Configuring terminal environment variables..."
    
    # Environment variables for better color support
    local env_config="
# 42 École Terminal Environment Configuration
export TERM=xterm-256color
export COLORTERM=truecolor

# Better color support for École 42 machines
if [[ \$TERM == \"xterm\" ]] || [[ \$TERM == \"screen\" ]]; then
    export TERM=xterm-256color
fi

# Enhanced bash history configuration
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S '
shopt -s histappend
shopt -s cmdhist
"
    
    # Add to .bashrc if it exists or create it
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "42 École Terminal Environment" "$HOME/.bashrc"; then
            echo "$env_config" >> "$HOME/.bashrc"
            print_module_status "Added environment config to .bashrc"
        fi
    else
        echo "$env_config" > "$HOME/.bashrc"
        print_module_status "Created .bashrc with environment config"
    fi
    
    # Add to .zshrc if it will be created later
    echo "$env_config" > "$HOME/.42_terminal_env"
    print_module_status "Environment config ready for shell integration"
    
    print_module_status "✅ Terminal environment configured"
}

# ============================================================================
# Verification Functions
# ============================================================================

verify_terminal_setup() {
    print_module_status "Verifying terminal setup..."
    
    local issues=()
    
    # Check font installation
    if fc-list | grep -qi "jetbrainsmono"; then
        print_module_status "✅ Font: JetBrains Mono Nerd Font installed"
    else
        issues+=("Font not installed")
    fi
    
    # Check color support
    if command -v tput >/dev/null 2>&1; then
        local colors=$(tput colors 2>/dev/null || echo "0")
        if [[ $colors -ge 256 ]]; then
            print_module_status "✅ Colors: $colors colors supported"
        else
            issues+=("Limited color support: $colors colors")
        fi
    else
        issues+=("Cannot verify color support")
    fi
    
    # Check environment variables
    if [[ "$TERM" == *"256color"* ]] || [[ "$TERM" == "xterm-256color" ]]; then
        print_module_status "✅ Environment: TERM=$TERM"
    else
        issues+=("TERM variable not optimal: $TERM")
    fi
    
    # Report results
    if [[ ${#issues[@]} -eq 0 ]]; then
        print_module_status "✅ Terminal setup verification passed"
        return 0
    else
        print_module_warning "Terminal setup has issues:"
        for issue in "${issues[@]}"; do
            print_module_warning "  - $issue"
        done
        return 1
    fi
}

# ============================================================================
# Main Terminal Setup Function
# ============================================================================

main() {
    print_module_status "🖥️  Starting terminal configuration..."
    
    local errors=0
    
    # Install font
    if ! install_jetbrains_mono_font; then
        ((errors++))
    fi
    
    # Configure terminal colors
    if ! configure_gnome_terminal_colors; then
        ((errors++))
    fi
    
    # Create reference file
    create_color_reference_file
    
    # Configure environment
    configure_terminal_environment
    
    # Verify setup
    if ! verify_terminal_setup; then
        ((errors++))
    fi
    
    # Summary
    if [[ $errors -eq 0 ]]; then
        print_module_status "🎉 Terminal module completed successfully!"
        print_module_status "💡 Restart terminal or run 'source ~/.bashrc' to apply changes"
    else
        print_module_warning "Terminal module completed with $errors issue(s)"
        print_module_status "Check ~/.catppuccin-mocha-reference.conf for manual configuration"
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