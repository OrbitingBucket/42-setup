#!/bin/bash

# 42 École Environment Verification Tests
# Comprehensive testing of all setup components

# ============================================================================
# Configuration
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNINGS=0

# ============================================================================
# Utility Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${PURPLE}🧪 42 École Environment Verification${NC}"
    echo -e "${CYAN}====================================${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}🔍 $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

test_pass() {
    echo -e "${GREEN}✅ $1${NC}"
    ((TESTS_PASSED++))
    ((TESTS_TOTAL++))
}

test_fail() {
    echo -e "${RED}❌ $1${NC}"
    ((TESTS_FAILED++))
    ((TESTS_TOTAL++))
}

test_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((TESTS_WARNINGS++))
    ((TESTS_TOTAL++))
}

# ============================================================================
# System Information Tests
# ============================================================================

test_system_info() {
    print_section "System Information"
    
    echo "User: $(whoami)"
    echo "Home: $HOME"
    echo "Shell: $SHELL"
    echo "System: $(uname -s) $(uname -r)"
    echo "Hostname: $(hostname)"
    echo "PWD: $PWD"
    
    # Check if we're on a 42 machine
    if [[ $(hostname) == *"42"* ]] || [[ $(pwd) == *"/sgoinfre/"* ]] || [[ -d "/sgoinfre" ]]; then
        test_pass "École 42 machine detected"
    else
        test_warning "Not an École 42 machine (testing environment)"
    fi
}

# ============================================================================
# Terminal Tests
# ============================================================================

test_terminal() {
    print_section "Terminal Configuration"
    
    # Test TERM variable
    if [[ "$TERM" == *"256color"* ]]; then
        test_pass "TERM variable: $TERM"
    else
        test_warning "TERM variable: $TERM (not optimal)"
    fi
    
    # Test color support
    if command -v tput >/dev/null 2>&1; then
        local colors=$(tput colors 2>/dev/null || echo "0")
        if [[ $colors -ge 256 ]]; then
            test_pass "Color support: $colors colors"
        else
            test_fail "Limited color support: $colors colors"
        fi
    else
        test_warning "Cannot verify color support (tput not available)"
    fi
    
    # Test COLORTERM
    if [[ -n "$COLORTERM" ]]; then
        test_pass "COLORTERM: $COLORTERM"
    else
        test_warning "COLORTERM not set"
    fi
    
    # Test true color support
    if [[ "$COLORTERM" == "truecolor" ]] || [[ "$COLORTERM" == "24bit" ]]; then
        test_pass "True color support detected"
    else
        test_warning "True color support uncertain"
    fi
    
    # Test font installation
    if command -v fc-list >/dev/null 2>&1; then
        if fc-list | grep -qi "jetbrainsmono"; then
            test_pass "JetBrains Mono Nerd Font installed"
        else
            test_fail "JetBrains Mono Nerd Font not found"
        fi
    else
        test_warning "Cannot verify font installation (fc-list not available)"
    fi
    
    # Test color reference file
    if [[ -f "$HOME/.catppuccin-mocha-reference.conf" ]]; then
        test_pass "Color reference file available"
    else
        test_warning "Color reference file not found"
    fi
}

# ============================================================================
# Vim Tests
# ============================================================================

test_vim() {
    print_section "Vim Configuration"
    
    # Test Vim availability
    if command -v vim >/dev/null 2>&1; then
        test_pass "Vim available: $(vim --version | head -1)"
    else
        test_fail "Vim not found"
        return
    fi
    
    # Test .vimrc
    if [[ -f "$HOME/.vimrc" ]]; then
        test_pass ".vimrc configuration file exists"
    else
        test_fail ".vimrc not found"
    fi
    
    # Test vim-plug
    if [[ -f "$HOME/.vim/autoload/plug.vim" ]]; then
        test_pass "vim-plug plugin manager installed"
    else
        test_fail "vim-plug not installed"
    fi
    
    # Test plugins directory
    if [[ -d "$HOME/.vim/plugged" ]]; then
        local plugin_count=$(ls -1 "$HOME/.vim/plugged" 2>/dev/null | wc -l)
        if [[ $plugin_count -gt 0 ]]; then
            test_pass "Plugins installed ($plugin_count plugins)"
        else
            test_warning "Plugins directory empty"
        fi
    else
        test_fail "Plugins directory not found"
    fi
    
    # Test Vim loading
    if vim -c "echo 'test'" -c "qa" >/dev/null 2>&1; then
        test_pass "Vim loads without errors"
    else
        test_fail "Vim has loading issues"
    fi
    
    # Test colorscheme
    if vim -c "try | colorscheme catppuccin_mocha | echo 'OK' | catch | echo 'FAIL' | endtry" -c "qa" 2>/dev/null | grep -q "OK"; then
        test_pass "Catppuccin theme loads correctly"
    else
        test_warning "Catppuccin theme not available"
    fi
    
    # Test terminal integration
    if vim -c "if has('terminal') | echo 'OK' | else | echo 'FAIL' | endif" -c "qa" 2>/dev/null | grep -q "OK"; then
        test_pass "Built-in terminal support available"
    else
        test_warning "Built-in terminal not supported"
    fi
    
    # Test key mappings (basic test)
    if grep -q "let mapleader" "$HOME/.vimrc" 2>/dev/null; then
        test_pass "Leader key configured"
    else
        test_warning "Leader key configuration not found"
    fi
    
    # Test cheatsheet
    if [[ -f "$HOME/.vim-42-cheatsheet.md" ]]; then
        test_pass "Vim cheatsheet available"
    else
        test_warning "Vim cheatsheet not found"
    fi
}

# ============================================================================
# Zsh Tests
# ============================================================================

test_zsh() {
    print_section "Zsh Configuration"
    
    # Test Zsh availability
    if command -v zsh >/dev/null 2>&1; then
        test_pass "Zsh available: $(zsh --version)"
    else
        test_fail "Zsh not found"
        return
    fi
    
    # Test Oh My Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        test_pass "Oh My Zsh installed"
    else
        test_fail "Oh My Zsh not installed"
    fi
    
    # Test .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        test_pass ".zshrc configuration file exists"
    else
        test_fail ".zshrc not found"
    fi
    
    # Test plugins
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugins_found=0
    
    if [[ -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        ((plugins_found++))
    fi
    if [[ -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        ((plugins_found++))
    fi
    
    if [[ $plugins_found -eq 2 ]]; then
        test_pass "All Zsh plugins installed"
    elif [[ $plugins_found -eq 1 ]]; then
        test_warning "Some Zsh plugins missing (1/2 installed)"
    else
        test_fail "Zsh plugins not installed"
    fi
    
    # Test Zsh loading
    if zsh -c "echo 'test'" >/dev/null 2>&1; then
        test_pass "Zsh loads without errors"
    else
        test_fail "Zsh has loading issues"
    fi
    
    # Test history configuration
    if grep -q "HISTSIZE=100000" "$HOME/.zshrc" 2>/dev/null; then
        test_pass "History configuration optimized"
    else
        test_warning "History configuration not optimal"
    fi
    
    # Test functions
    if grep -q "42new()" "$HOME/.zshrc" 2>/dev/null; then
        test_pass "42-specific functions available"
    else
        test_warning "42 functions not found"
    fi
    
    # Test cheatsheet
    if [[ -f "$HOME/.zsh-42-cheatsheet.md" ]]; then
        test_pass "Zsh cheatsheet available"
    else
        test_warning "Zsh cheatsheet not found"
    fi
}

# ============================================================================
# Directory Structure Tests
# ============================================================================

test_directories() {
    print_section "Directory Structure"
    
    local directories=(
        "$HOME/code"
        "$HOME/code/42"
        "$HOME/code/personal"
        "$HOME/code/tmp"
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share/fonts"
    )
    
    for dir in "${directories[@]}"; do
        if [[ -d "$dir" ]]; then
            test_pass "Directory exists: $dir"
        else
            test_fail "Directory missing: $dir"
        fi
    done
}

# ============================================================================
# Development Tools Tests
# ============================================================================

test_development_tools() {
    print_section "Development Tools"
    
    local tools=("gcc" "make" "git" "curl" "unzip")
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            test_pass "$tool available"
        else
            test_fail "$tool not found"
        fi
    done
    
    # Test norminette (optional)
    if command -v norminette >/dev/null 2>&1; then
        test_pass "Norminette available"
    else
        test_warning "Norminette not installed (install from 42 intranet)"
    fi
    
    # Test valgrind (optional)
    if command -v valgrind >/dev/null 2>&1; then
        test_pass "Valgrind available"
    else
        test_warning "Valgrind not installed"
    fi
}

# ============================================================================
# Integration Tests
# ============================================================================

test_integration() {
    print_section "Integration Tests"
    
    # Test aliases loading
    if command -v 42 >/dev/null 2>&1 || (source ~/.bashrc 2>/dev/null && command -v 42 >/dev/null 2>&1); then
        test_pass "42 navigation alias available"
    else
        test_warning "42 alias not available in current session"
    fi
    
    # Test environment variables
    local env_vars=("TERM" "HOME" "USER")
    for var in "${env_vars[@]}"; do
        if [[ -n "${!var}" ]]; then
            test_pass "Environment variable $var set"
        else
            test_warning "Environment variable $var not set"
        fi
    done
    
    # Test backup system
    if [[ -f "$HOME/.42setup_last_backup" ]]; then
        test_pass "Backup system functional"
    else
        test_warning "No backup record found"
    fi
}

# ============================================================================
# Performance Tests
# ============================================================================

test_performance() {
    print_section "Performance & Resources"
    
    # Test available disk space
    local available_space=$(df -h "$HOME" | awk 'NR==2 {print $4}')
    if [[ -n "$available_space" ]]; then
        test_pass "Available disk space: $available_space"
    else
        test_warning "Cannot determine disk space"
    fi
    
    # Test memory usage
    if command -v free >/dev/null 2>&1; then
        local memory_info=$(free -h | awk 'NR==2{printf "Used: %s/%s (%.1f%%)", $3,$2,$3*100/$2}')
        test_pass "Memory usage: $memory_info"
    else
        test_warning "Cannot determine memory usage"
    fi
    
    # Test load average
    if [[ -f /proc/loadavg ]]; then
        local load_avg=$(cat /proc/loadavg | cut -d' ' -f1-3)
        test_pass "Load average: $load_avg"
    else
        test_warning "Cannot determine load average"
    fi
}

# ============================================================================
# Main Test Runner
# ============================================================================

run_quick_tests() {
    # Quick smoke tests for basic functionality
    local quick_issues=()
    
    [[ ! -f "$HOME/.vimrc" ]] && quick_issues+=("Vim config missing")
    [[ ! -d "$HOME/.oh-my-zsh" ]] && quick_issues+=("Oh My Zsh missing")
    [[ ! -d "$HOME/code/42" ]] && quick_issues+=("42 directory missing")
    [[ "$TERM" != *"256color"* ]] && quick_issues+=("Terminal colors suboptimal")
    
    if [[ ${#quick_issues[@]} -eq 0 ]]; then
        echo -e "${GREEN}🚀 Quick test: All core components present${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Quick test found issues:${NC}"
        for issue in "${quick_issues[@]}"; do
            echo -e "${YELLOW}   - $issue${NC}"
        done
        return 1
    fi
}

show_summary() {
    echo ""
    echo -e "${PURPLE}📊 Test Summary${NC}"
    echo "$(printf '=%.0s' {1..30})"
    echo -e "Total tests: ${BLUE}$TESTS_TOTAL${NC}"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
    echo -e "Warnings: ${YELLOW}$TESTS_WARNINGS${NC}"
    echo ""
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}🎉 All critical tests passed!${NC}"
        echo -e "${GREEN}✅ Your 42 environment is ready!${NC}"
        return 0
    elif [[ $TESTS_FAILED -le 2 ]]; then
        echo -e "${YELLOW}⚠️  Minor issues found, but environment is usable${NC}"
        return 1
    else
        echo -e "${RED}❌ Multiple issues found, setup may need attention${NC}"
        return 2
    fi
}

show_next_steps() {
    echo ""
    echo -e "${CYAN}📋 Next Steps${NC}"
    echo "$(printf '=%.0s' {1..20})"
    echo "1. Restart terminal: source ~/.bashrc"
    echo "2. Try Zsh: zsh"
    echo "3. Navigate to projects: 42"
    echo "4. Test Vim: vim test.c"
    echo "5. Create project: 42new myproject"
    echo ""
    echo -e "${BLUE}📚 Resources${NC}"
    echo "- Vim cheatsheet: ~/.vim-42-cheatsheet.md"
    echo "- Zsh cheatsheet: ~/.zsh-42-cheatsheet.md"
    echo "- Color reference: ~/.catppuccin-mocha-reference.conf"
    echo "- Setup log: ~/.42setup.log"
    echo ""
}

main() {
    print_header
    
    # Run all test suites
    test_system_info
    test_directories
    test_development_tools
    test_terminal
    test_vim
    test_zsh
    test_integration
    test_performance
    
    # Show results
    local exit_code
    show_summary
    exit_code=$?
    
    show_next_steps
    
    echo -e "${CYAN}Happy coding at École 42! 🌍🎓${NC}"
    echo ""
    
    return $exit_code
}

# ============================================================================
# Script Entry Point
# ============================================================================

# Handle arguments
case "${1:-}" in
    --quick|-q)
        print_header
        run_quick_tests
        exit $?
        ;;
    --help|-h)
        echo "42 École Environment Verification"
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --quick, -q    Run quick smoke tests only"
        echo "  --help, -h     Show this help message"
        echo ""
        exit 0
        ;;
esac

# Run main verification if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi