#!/bin/bash

# 42 École Enhanced Environment Setup Script
# Complete reproduction of your optimized development environment
# No admin rights required - perfect for École 42 piscine
# 
# Usage: ./setup-enhanced.sh [options]
# GitHub: https://github.com/OrbitingBucket/42-setup

set -e

# ============================================================================
# Configuration
# ============================================================================

SCRIPT_VERSION="3.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.42setup_enhanced.log"
BACKUP_DIR=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration options (can be set via environment variables)
SKIP_BACKUP=${SKIP_BACKUP:-false}
SKIP_VIM=${SKIP_VIM:-false}
SKIP_ZSH=${SKIP_ZSH:-false}
SKIP_TERMINAL=${SKIP_TERMINAL:-false}
SKIP_BASH=${SKIP_BASH:-false}
DRY_RUN=${DRY_RUN:-false}

# ============================================================================
# Utility Functions
# ============================================================================

print_header() {
    echo -e "${PURPLE}🎓 42 École Enhanced Environment Setup v${SCRIPT_VERSION}${NC}"
    echo -e "${CYAN}============================================================${NC}"
    echo ""
    echo -e "${BLUE}📋 What will be configured:${NC}"
    echo "   • Bash with École 42 optimizations and fasd navigation"
    echo "   • Zsh with Oh My Zsh (manual activation, no shell switching)"
    echo "   • Vim with NvChad-like features and École 42 integration"
    echo "   • Terminal colors (Catppuccin Mocha theme)"
    echo "   • JetBrains Mono Nerd Font"
    echo "   • Complete backup of existing configurations"
    echo ""
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log_message "INFO" "$1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    log_message "WARNING" "$1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log_message "ERROR" "$1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
    log_message "STEP" "$1"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" >> "$LOG_FILE"
}

# ============================================================================
# Prerequisites and Environment Detection
# ============================================================================

check_prerequisites() {
    print_step "Checking prerequisites..."
    
    local missing_commands=()
    local required_commands=("curl" "git" "bash")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [[ ${#missing_commands[@]} -gt 0 ]]; then
        print_error "Missing required commands: ${missing_commands[*]}"
        print_error "Please install these commands before running the setup"
        return 1
    fi
    
    # Check internet connectivity
    if ! curl -s --head --connect-timeout 5 "https://github.com" >/dev/null; then
        print_warning "No internet connection detected - some features may be limited"
    fi
    
    print_status "✅ Prerequisites check passed"
    return 0
}

detect_environment() {
    print_step "Detecting environment..."
    
    local is_42_machine=false
    local is_school_env=false
    
    # Check various indicators for École 42 machines
    if [[ $(hostname) == *"42"* ]] || [[ $(pwd) == *"/sgoinfre/"* ]] || [[ -d "/sgoinfre" ]] || [[ -d "/home/42"* ]]; then
        is_42_machine=true
    fi
    
    # Check for common school environment indicators
    if [[ -d "/usr/share/school" ]] || [[ "$USER" == "student" ]] || [[ $(groups) == *"student"* ]]; then
        is_school_env=true
    fi
    
    if $is_42_machine; then
        print_status "✅ École 42 machine detected"
        export SETUP_42_MACHINE=true
    else
        print_status "ℹ️  Not an École 42 machine, but continuing..."
        export SETUP_42_MACHINE=false
    fi
    
    if $is_school_env; then
        print_status "🏫 School environment detected - using non-admin mode"
        export SETUP_SCHOOL_ENV=true
    else
        export SETUP_SCHOOL_ENV=false
    fi
    
    # Environment info
    print_status "User: $(whoami)"
    print_status "Home: $HOME"
    print_status "Shell: $SHELL"
    print_status "System: $(uname -s) $(uname -r)"
    print_status "Directory: $(pwd)"
}

# ============================================================================
# Directory Structure Setup
# ============================================================================

create_directory_structure() {
    print_step "Creating directory structure..."
    
    local directories=(
        "$HOME/code/42"
        "$HOME/code/personal" 
        "$HOME/code/tmp"
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share/fonts"
        "$HOME/.vim/undo"
    )
    
    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            print_status "Created: $dir"
        else
            print_status "Exists: $dir"
        fi
    done
    
    print_status "✅ Directory structure ready"
}

# ============================================================================
# Module Execution Functions
# ============================================================================

run_backup() {
    if $SKIP_BACKUP; then
        print_warning "Skipping backup (SKIP_BACKUP=true)"
        return 0
    fi
    
    print_step "Creating backup of existing configurations..."
    
    if [[ -f "$SCRIPT_DIR/backup.sh" ]]; then
        if bash "$SCRIPT_DIR/backup.sh"; then
            # Get the backup directory
            if [[ -f "$HOME/.42setup_last_backup" ]]; then
                BACKUP_DIR=$(cat "$HOME/.42setup_last_backup")
                print_status "✅ Backup completed: $BACKUP_DIR"
            else
                print_status "✅ Backup completed"
            fi
            return 0
        else
            print_error "Backup failed"
            return 1
        fi
    else
        print_warning "Backup script not found, skipping backup"
        return 1
    fi
}

run_module() {
    local module_name="$1"
    local module_script="$SCRIPT_DIR/modules/$module_name.sh"
    
    # Check if module should be skipped
    local skip_var="SKIP_${module_name^^}"
    if [[ "${!skip_var}" == "true" ]]; then
        print_warning "Skipping $module_name module (${skip_var}=true)"
        return 0
    fi
    
    print_step "Running $module_name module..."
    
    if [[ ! -f "$module_script" ]]; then
        print_error "Module script not found: $module_script"
        return 1
    fi
    
    if $DRY_RUN; then
        print_status "DRY RUN: Would execute $module_script"
        return 0
    fi
    
    # Execute the module script
    if bash "$module_script"; then
        print_status "✅ $module_name module completed successfully"
        return 0
    else
        print_error "❌ $module_name module failed"
        return 1
    fi
}

# ============================================================================
# Verification Functions
# ============================================================================

verify_installation() {
    print_step "Verifying installation..."
    
    local issues=0
    
    # Check if config files exist
    local config_files=(".bashrc" ".vimrc")
    for config in "${config_files[@]}"; do
        if [[ -f "$HOME/$config" ]]; then
            print_status "✅ Config exists: $config"
        else
            print_error "❌ Config missing: $config"
            issues=$((issues + 1))
        fi
    done
    
    # Check if .zshrc exists (optional)
    if [[ -f "$HOME/.zshrc" ]]; then
        print_status "✅ Zsh config exists"
    else
        print_warning "⚠️  Zsh config not found (optional)"
    fi
    
    # Check if vim plugins directory exists
    if [[ -d "$HOME/.vim/plugged" ]]; then
        print_status "✅ Vim plugins directory exists"
    else
        print_warning "⚠️  Vim plugins directory not found"
    fi
    
    # Check if 42 aliases exist
    if [[ -f "$HOME/.42_aliases" ]]; then
        print_status "✅ 42 École aliases exist"
    else
        print_warning "⚠️  42 École aliases not found"
    fi
    
    # Check font installation
    if command -v fc-list >/dev/null 2>&1; then
        if fc-list | grep -qi "jetbrains"; then
            print_status "✅ JetBrains font detected"
        else
            print_warning "⚠️  JetBrains font not detected"
        fi
    fi
    
    # Check terminal color support
    if [[ "$TERM" == *"256color"* ]] || [[ "$COLORTERM" == "truecolor" ]]; then
        print_status "✅ Terminal color support detected"
    else
        print_warning "⚠️  Limited terminal color support"
    fi
    
    if [[ $issues -eq 0 ]]; then
        print_status "🎉 Installation verification passed!"
        return 0
    else
        print_error "❌ Installation has $issues critical issues"
        return 1
    fi
}

# ============================================================================
# Completion and Help Functions
# ============================================================================

show_completion_message() {
    echo ""
    echo -e "${PURPLE}🎉 42 École Enhanced Environment Setup Complete!${NC}"
    echo -e "${CYAN}====================================================${NC}"
    echo ""
    echo -e "${GREEN}✅ What's been configured:${NC}"
    echo "   • Bash with École 42 optimizations, fasd navigation, and custom functions"
    echo "   • Zsh with Oh My Zsh (available via 'zsh' command)"
    echo "   • Vim with advanced features, plugins, and École 42 integration"
    echo "   • Terminal colors (Catppuccin Mocha theme)"
    echo "   • JetBrains Mono Nerd Font"
    echo "   • Complete backup of previous configurations"
    echo ""
    echo -e "${BLUE}🚀 Getting Started:${NC}"
    echo "   source ~/.bashrc           # Reload bash configuration"
    echo "   42help                     # Show all available commands"
    echo "   42                        # Go to projects directory"
    echo "   vim test.c                # Test enhanced Vim setup"
    echo "   zsh                       # Start enhanced Zsh environment"
    echo ""
    echo -e "${CYAN}📚 Key Commands:${NC}"
    echo ""
    echo -e "${YELLOW}Navigation:${NC}"
    echo "   42                        # cd ~/code/42"
    echo "   code                      # cd ~/code"
    echo "   j <partial_name>          # Fast directory jumping with fasd"
    echo "   n <partial_name>          # Fast file opening with fasd"
    echo ""
    echo -e "${YELLOW}Development:${NC}"
    echo "   42new <project>           # Create new 42 project with Makefile"
    echo "   ctest file.c              # Quick compile, run, and cleanup"
    echo "   cc file.c                 # Compile with 42 flags (-Wall -Wextra -Werror)"
    echo "   normcheck file.c          # Check norminette compliance"
    echo ""
    echo -e "${YELLOW}Git Workflow:${NC}"
    echo "   gcom \"message\"            # git add all + commit"
    echo "   gacp \"message\"            # git add all + commit + push"
    echo "   gs                        # git status"
    echo "   glog                      # pretty git log"
    echo ""
    echo -e "${YELLOW}Vim Features:${NC}"
    echo "   <space>h                  # Toggle terminal (horizontal)"
    echo "   <space>v                  # Toggle terminal (vertical)"
    echo "   <space>e                  # Toggle file tree (NERDTree)"
    echo "   <space>f                  # Fuzzy file finder (FZF)"
    echo "   <space>cc                 # Compile C file"
    echo "   <space>cn                 # Check norminette"
    echo "   F1                        # Insert 42 header"
    echo ""
    echo -e "${GREEN}🔧 Troubleshooting:${NC}"
    echo "   ~/.42setup_enhanced.log   # Setup log file"
    if [[ -n "$BACKUP_DIR" ]]; then
        echo "   $BACKUP_DIR  # Your configuration backup"
        echo "   ./backup.sh restore       # Restore previous configuration"
    fi
    echo "   ./setup-enhanced.sh --help # Show all options"
    echo ""
    echo -e "${CYAN}📖 Documentation:${NC}"
    echo "   cat ~/.zsh-42-cheatsheet.md    # Zsh command reference"
    echo "   42help                         # Bash command reference"
    echo "   https://github.com/OrbitingBucket/42-setup"
    echo ""
    echo -e "${GREEN}🌍 École 42 Campus Compatibility:${NC}"
    echo "   ✅ Works on all École 42 campuses worldwide"
    echo "   ✅ No admin rights required"
    echo "   ✅ Norminette compliant"
    echo "   ✅ Respects École 42 coding standards"
    echo ""
}

show_help() {
    echo "42 École Enhanced Environment Setup"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h            Show this help message"
    echo "  --version, -v         Show version information"
    echo "  --dry-run            Show what would be done without making changes"
    echo "  --skip-backup        Skip configuration backup"
    echo "  --skip-vim           Skip Vim configuration"
    echo "  --skip-zsh           Skip Zsh configuration"
    echo "  --skip-terminal      Skip terminal configuration"
    echo "  --skip-bash          Skip bash configuration"
    echo ""
    echo "Environment Variables:"
    echo "  SKIP_BACKUP=true     Skip configuration backup"
    echo "  SKIP_VIM=true        Skip Vim module"
    echo "  SKIP_ZSH=true        Skip Zsh module"
    echo "  SKIP_TERMINAL=true   Skip terminal module"
    echo "  SKIP_BASH=true       Skip bash module"
    echo "  DRY_RUN=true         Show what would be done"
    echo ""
    echo "Examples:"
    echo "  $0                   # Full setup"
    echo "  $0 --skip-zsh        # Setup without Zsh"
    echo "  $0 --dry-run         # Preview what will be done"
    echo "  SKIP_BACKUP=true $0  # Skip backup"
    echo ""
    echo "Individual modules can also be run separately:"
    echo "  ./modules/bash.sh         # Only bash configuration"
    echo "  ./modules/vim.sh          # Only vim configuration"
    echo "  ./modules/zsh.sh          # Only zsh configuration"
    echo "  ./modules/terminal.sh     # Only terminal configuration"
    echo "  ./backup.sh               # Only backup"
    echo ""
    echo "Backup/Restore:"
    echo "  ./backup.sh               # Create backup"
    echo "  ./backup.sh list          # List available backups"
    echo "  ./backup.sh restore       # Restore last backup"
}

# ============================================================================
# Main Setup Function
# ============================================================================

main() {
    # Initialize log
    echo "42 École Enhanced Setup started at $(date)" > "$LOG_FILE"
    
    print_header
    
    # Phase 1: Prerequisites and environment setup
    check_prerequisites || exit 1
    detect_environment
    create_directory_structure
    
    # Phase 2: Backup existing configuration
    if ! run_backup; then
        print_warning "Backup failed, but continuing with setup..."
    fi
    
    # Phase 3: Module installation
    local modules=("bash" "terminal" "vim" "zsh")
    local failed_modules=()
    local successful_modules=()
    
    for module in "${modules[@]}"; do
        echo ""
        print_step "Starting $module module..."
        
        if run_module "$module"; then
            successful_modules+=("$module")
        else
            failed_modules+=("$module")
        fi
    done
    
    # Phase 4: Verification and completion
    echo ""
    verify_installation
    
    # Phase 5: Report results
    echo ""
    if [[ ${#failed_modules[@]} -eq 0 ]]; then
        show_completion_message
        print_status "🎯 Setup completed successfully!"
    else
        print_warning "Setup completed with some issues:"
        for module in "${failed_modules[@]}"; do
            print_warning "  - $module module failed"
        done
        echo ""
        if [[ ${#successful_modules[@]} -gt 0 ]]; then
            print_status "Successful modules: ${successful_modules[*]}"
        fi
        print_status "Check log file: $LOG_FILE"
        echo ""
        show_completion_message
    fi
    
    echo ""
    echo -e "${CYAN}Happy coding at École 42! 🌍🎓${NC}"
    
    return 0
}

# ============================================================================
# Script Entry Point
# ============================================================================

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            exit 0
            ;;
        --version|-v)
            echo "42 École Enhanced Setup v$SCRIPT_VERSION"
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --skip-vim)
            SKIP_VIM=true
            shift
            ;;
        --skip-zsh)
            SKIP_ZSH=true
            shift
            ;;
        --skip-terminal)
            SKIP_TERMINAL=true
            shift
            ;;
        --skip-bash)
            SKIP_BASH=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main installation if script is executed (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi