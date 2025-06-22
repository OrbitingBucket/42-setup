#!/bin/bash

# 42 École Environment Setup - Main Orchestrator
# Usage: curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup.sh | bash
# GitHub: https://github.com/OrbitingBucket/42-setup

set -e  # Exit on any error

# ============================================================================
# Configuration
# ============================================================================

REPO_URL="https://raw.githubusercontent.com/OrbitingBucket/42-setup/main"
SCRIPT_VERSION="2.0.0"
LOG_FILE="$HOME/.42setup.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# Utility Functions
# ============================================================================

print_header() {
    echo -e "${PURPLE}🎓 42 École Environment Setup v${SCRIPT_VERSION}${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo ""
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" >> "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [WARNING] $1" >> "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $1" >> "$LOG_FILE"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [STEP] $1" >> "$LOG_FILE"
}

check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check required commands
    local required_commands=("curl" "git")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            print_error "Required command '$cmd' not found"
            return 1
        fi
    done
    
    # Check internet connectivity
    if ! curl -s --head "$REPO_URL/README.md" >/dev/null; then
        print_error "Cannot connect to GitHub repository"
        return 1
    fi
    
    print_status "✅ Prerequisites check passed"
}

detect_environment() {
    print_step "Detecting environment..."
    
    local is_42_machine=false
    
    # Check various indicators for École 42 machines
    if [[ $(hostname) == *"42"* ]] || [[ $(pwd) == *"/sgoinfre/"* ]] || [[ -d "/sgoinfre" ]]; then
        is_42_machine=true
    fi
    
    if $is_42_machine; then
        print_status "✅ École 42 machine detected"
        export SETUP_42_MACHINE=true
    else
        print_warning "Not an École 42 machine, but continuing..."
        export SETUP_42_MACHINE=false
    fi
    
    print_status "User: $(whoami)"
    print_status "Home: $HOME"
    print_status "Shell: $SHELL"
    print_status "System: $(uname -s) $(uname -r)"
}

backup_existing_configs() {
    print_step "Backing up existing configurations..."
    
    local backup_dir="$HOME/.42setup_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    local configs=(".vimrc" ".vim" ".zshrc" ".bashrc" ".42_aliases")
    local backed_up=false
    
    for config in "${configs[@]}"; do
        if [[ -e "$HOME/$config" ]]; then
            cp -r "$HOME/$config" "$backup_dir/"
            print_status "Backed up $config"
            backed_up=true
        fi
    done
    
    if $backed_up; then
        print_status "✅ Configs backed up to: $backup_dir"
        echo "$backup_dir" > "$HOME/.42setup_last_backup"
    else
        print_status "No existing configs to backup"
        rmdir "$backup_dir"
    fi
}

create_directory_structure() {
    print_step "Creating directory structure..."
    
    local directories=(
        "$HOME/code/42"
        "$HOME/code/personal" 
        "$HOME/code/tmp"
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share/fonts"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        print_status "Created: $dir"
    done
    
    print_status "✅ Directory structure created"
}

download_and_run_module() {
    local module_name="$1"
    local module_url="$REPO_URL/modules/$module_name.sh"
    
    print_step "Running $module_name module..."
    
    if curl -sSL "$module_url" | bash; then
        print_status "✅ $module_name module completed successfully"
        return 0
    else
        print_error "❌ $module_name module failed"
        return 1
    fi
}

run_verification() {
    print_step "Running environment verification..."
    
    if curl -sSL "$REPO_URL/tests/verify.sh" | bash; then
        print_status "✅ Verification passed"
        return 0
    else
        print_warning "⚠️  Verification found issues"
        return 1
    fi
}

show_completion_message() {
    echo ""
    echo -e "${PURPLE}🎉 42 École Environment Setup Complete!${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    echo -e "${GREEN}✅ What's been configured:${NC}"
    echo "   • Terminal colors (Catppuccin Mocha theme)"
    echo "   • JetBrains Mono Nerd Font"
    echo "   • Enhanced Vim with NvChad-like features"
    echo "   • Oh My Zsh (available, no shell switching)"
    echo "   • 42-specific aliases and functions in bash"
    echo ""
    echo -e "${BLUE}🚀 Quick Start (staying in bash):${NC}"
    echo "   source ~/.bashrc          # Reload bash configuration"
    echo "   42                        # Go to projects directory"
    echo "   vim test.c                # Test enhanced Vim setup"
    echo "   zsh                       # Optional: try Zsh (type 'exit' to return)"
    echo ""
    echo -e "${CYAN}📚 Key Commands:${NC}"
    echo "   <space>h                  # Toggle terminal in Vim"
    echo "   <space>e                  # Toggle file tree in Vim"
    echo "   42new <project>           # Create new 42 project"
    echo "   ctest file.c              # Quick compile and test"
    echo ""
    echo -e "${YELLOW}📖 Full documentation:${NC}"
    echo "   https://github.com/OrbitingBucket/42-setup"
    echo ""
    echo -e "${GREEN}🔧 Troubleshooting:${NC}"
    echo "   Log file: $LOG_FILE"
    if [[ -f "$HOME/.42setup_last_backup" ]]; then
        echo "   Backup: $(cat "$HOME/.42setup_last_backup")"
    fi
    echo ""
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    # Initialize log
    echo "42 École Setup started at $(date)" > "$LOG_FILE"
    
    print_header
    
    # Phase 1: Environment setup
    check_prerequisites || exit 1
    detect_environment
    backup_existing_configs
    create_directory_structure
    
    # Phase 2: Module installation
    local modules=("terminal" "vim" "zsh")
    local failed_modules=()
    
    for module in "${modules[@]}"; do
        if ! download_and_run_module "$module"; then
            failed_modules+=("$module")
        fi
    done
    
    # Phase 3: Verification and completion
    run_verification
    
    # Report results
    if [[ ${#failed_modules[@]} -eq 0 ]]; then
        show_completion_message
        print_status "🎯 Setup completed successfully!"
    else
        print_warning "Setup completed with some issues:"
        for module in "${failed_modules[@]}"; do
            print_warning "  - $module module failed"
        done
        print_status "Check log file: $LOG_FILE"
    fi
    
    echo ""
    echo -e "${CYAN}Happy coding at École 42! 🌍🎓${NC}"
}

# ============================================================================
# Script Entry Point
# ============================================================================

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "42 École Environment Setup"
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version, -v  Show version information"
        echo ""
        echo "Environment Variables:"
        echo "  SETUP_SKIP_BACKUP=1    Skip configuration backup"
        echo "  SETUP_MODULES='vim'     Only run specific modules"
        echo ""
        exit 0
        ;;
    --version|-v)
        echo "42 École Setup v$SCRIPT_VERSION"
        exit 0
        ;;
esac

# Run main installation if script is executed (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi