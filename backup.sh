#!/bin/bash

# 42 École Configuration Backup Script
# Creates timestamped backups of existing configurations
# Usage: ./backup.sh [restore]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Configuration files to backup
CONFIG_FILES=(
    ".bashrc"
    ".zshrc"
    ".vimrc"
    ".profile"
    ".bash_aliases"
    ".gitconfig"
)

CONFIG_DIRS=(
    ".vim"
    ".oh-my-zsh"
    ".config/fontconfig"
    ".local/share/fonts"
)

backup_configurations() {
    local backup_dir="$HOME/.42setup_backup_$(date +%Y%m%d_%H%M%S)"
    
    print_step "Creating backup directory: $backup_dir"
    mkdir -p "$backup_dir"
    
    local backed_up=false
    
    # Backup configuration files
    for config in "${CONFIG_FILES[@]}"; do
        if [[ -f "$HOME/$config" ]]; then
            cp "$HOME/$config" "$backup_dir/"
            print_status "Backed up $config"
            backed_up=true
        fi
    done
    
    # Backup configuration directories
    for config_dir in "${CONFIG_DIRS[@]}"; do
        if [[ -d "$HOME/$config_dir" ]]; then
            cp -r "$HOME/$config_dir" "$backup_dir/"
            print_status "Backed up $config_dir"
            backed_up=true
        fi
    done
    
    # Backup terminal profiles (GNOME Terminal)
    if command -v dconf >/dev/null 2>&1; then
        print_step "Backing up terminal profiles..."
        dconf dump /org/gnome/terminal/ > "$backup_dir/gnome-terminal-profiles.dconf"
        print_status "Backed up GNOME Terminal profiles"
        backed_up=true
    fi
    
    if $backed_up; then
        echo "$backup_dir" > "$HOME/.42setup_last_backup"
        print_status "✅ Backup completed successfully!"
        print_status "Backup location: $backup_dir"
        echo ""
        echo -e "${CYAN}To restore this backup later, run:${NC}"
        echo "  $0 restore $backup_dir"
    else
        print_warning "No configurations found to backup"
        rmdir "$backup_dir"
    fi
}

list_backups() {
    print_step "Available backups:"
    
    local backup_count=0
    for backup in "$HOME"/.42setup_backup_*; do
        if [[ -d "$backup" ]]; then
            local backup_name=$(basename "$backup")
            local backup_date=$(echo "$backup_name" | sed 's/.*_\([0-9]\{8\}_[0-9]\{6\}\)/\1/')
            local formatted_date=$(echo "$backup_date" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)_\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5:\6/')
            
            echo "  $backup ($formatted_date)"
            backup_count=$((backup_count + 1))
        fi
    done
    
    if [[ $backup_count -eq 0 ]]; then
        print_warning "No backups found"
    else
        echo ""
        if [[ -f "$HOME/.42setup_last_backup" ]]; then
            local last_backup=$(cat "$HOME/.42setup_last_backup")
            print_status "Last backup: $last_backup"
        fi
    fi
}

restore_backup() {
    local backup_dir="$1"
    
    if [[ -z "$backup_dir" ]]; then
        if [[ -f "$HOME/.42setup_last_backup" ]]; then
            backup_dir=$(cat "$HOME/.42setup_last_backup")
            print_status "Using last backup: $backup_dir"
        else
            print_error "No backup directory specified and no last backup found"
            echo "Usage: $0 restore <backup_directory>"
            list_backups
            exit 1
        fi
    fi
    
    if [[ ! -d "$backup_dir" ]]; then
        print_error "Backup directory not found: $backup_dir"
        list_backups
        exit 1
    fi
    
    print_step "Restoring from: $backup_dir"
    
    # Create a new backup before restoring
    print_step "Creating backup of current configuration before restore..."
    backup_configurations
    
    # Restore files
    for config in "${CONFIG_FILES[@]}"; do
        if [[ -f "$backup_dir/$config" ]]; then
            cp "$backup_dir/$config" "$HOME/"
            print_status "Restored $config"
        fi
    done
    
    # Restore directories
    for config_dir in "${CONFIG_DIRS[@]}"; do
        if [[ -d "$backup_dir/$config_dir" ]]; then
            rm -rf "$HOME/$config_dir"
            cp -r "$backup_dir/$config_dir" "$HOME/"
            print_status "Restored $config_dir"
        fi
    done
    
    # Restore terminal profiles
    if [[ -f "$backup_dir/gnome-terminal-profiles.dconf" ]]; then
        if command -v dconf >/dev/null 2>&1; then
            dconf load /org/gnome/terminal/ < "$backup_dir/gnome-terminal-profiles.dconf"
            print_status "Restored GNOME Terminal profiles"
        fi
    fi
    
    print_status "✅ Restore completed successfully!"
    echo ""
    echo -e "${CYAN}Please restart your terminal or run:${NC}"
    echo "  source ~/.bashrc"
    echo "  source ~/.zshrc  # if using zsh"
}

show_help() {
    echo "42 École Configuration Backup Tool"
    echo ""
    echo "Usage:"
    echo "  $0                    # Create backup of current configuration"
    echo "  $0 backup            # Same as above"
    echo "  $0 list              # List available backups"
    echo "  $0 restore [DIR]     # Restore from backup (uses last backup if DIR not specified)"
    echo "  $0 help              # Show this help"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 restore ~/.42setup_backup_20241225_143022"
    echo "  $0 list"
}

main() {
    case "${1:-backup}" in
        backup|"")
            backup_configurations
            ;;
        restore)
            restore_backup "$2"
            ;;
        list)
            list_backups
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi