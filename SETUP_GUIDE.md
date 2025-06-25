# 42 École Setup - Enhanced Configuration Reproduction

This repository contains scripts to quickly reproduce your optimized development environment on any École 42 machine or Ubuntu system without admin rights.

## 🚀 Quick Start (One Command)

```bash
# Clone and run complete setup
git clone https://github.com/your-username/42-setup.git
cd 42-setup
./setup-enhanced.sh
```

## 📋 What Gets Configured

### ✅ Bash Environment
- **Optimized .bashrc** with École 42 settings
- **Fast directory navigation** with fasd (j, n commands)
- **42-specific aliases and functions** (42new, ctest, normcheck)
- **Enhanced history** (100k commands, timestamps, deduplication)
- **Git workflow shortcuts** (gcom, gacp, gs, glog)

### ✅ Zsh Environment (Optional)
- **Oh My Zsh** with plugins (autosuggestions, syntax highlighting)
- **Manual activation** (no shell switching, type 'zsh' to use)
- **Same 42 functions** as bash environment
- **Enhanced completion** and history search

### ✅ Vim Environment
- **Advanced configuration** with NvChad-like features
- **Essential plugins**: NERDTree, FZF, auto-pairs, surround, lightline
- **42 École integration**: header generator (F1), norminette check
- **Terminal integration**: horizontal/vertical terminal toggles
- **Catppuccin Mocha theme** with proper syntax highlighting

### ✅ Terminal Environment
- **Catppuccin Mocha color scheme** (matches your home setup)
- **JetBrains Mono Nerd Font** installation
- **256-color and truecolor support**
- **GNOME Terminal profile** creation and configuration

## 🛠️ Individual Module Usage

### Run Specific Components
```bash
# Only bash configuration
./modules/bash.sh

# Only vim setup
./modules/vim.sh

# Only terminal colors
./modules/terminal.sh

# Only zsh setup
./modules/zsh.sh
```

### Backup and Restore
```bash
# Create backup of current configuration
./backup.sh

# List available backups
./backup.sh list

# Restore from backup
./backup.sh restore

# Restore specific backup
./backup.sh restore ~/.42setup_backup_20241225_143022
```

## 🎯 École 42 Specific Features

### Development Workflow
```bash
# Create new 42 project with Makefile
42new ft_printf

# Quick compile and test
ctest main.c

# Compile with 42 flags
cc -Wall -Wextra -Werror main.c

# Check norminette compliance
normcheck main.c

# Navigate quickly
42          # Go to ~/code/42
code        # Go to ~/code
j printf    # Jump to ft_printf directory (fasd)
```

### Git Workflow
```bash
# Quick commit workflow
gcom "Add main function"        # git add all + commit
gacp "Fix norminette errors"    # git add all + commit + push
gs                              # git status
glog                            # pretty git log
```

### Vim Shortcuts
```bash
# In Vim (leader key is space)
<space>h    # Toggle horizontal terminal
<space>v    # Toggle vertical terminal
<space>e    # Toggle file tree
<space>f    # Fuzzy file finder
<space>cc   # Compile C file
<space>cn   # Check norminette
F1          # Insert 42 header template
```

## 🔧 Advanced Options

### Setup Script Options
```bash
# Preview what will be done (no changes)
./setup-enhanced.sh --dry-run

# Skip specific components
./setup-enhanced.sh --skip-zsh --skip-terminal

# Skip backup (faster setup)
./setup-enhanced.sh --skip-backup

# Environment variable control
SKIP_VIM=true ./setup-enhanced.sh
```

### Non-Admin Compatibility
- ✅ **No sudo required** - Everything installs to user directories
- ✅ **Font installation** to ~/.local/share/fonts
- ✅ **Package management** via user space (curl downloads)
- ✅ **Shell configuration** without chsh command
- ✅ **Terminal configuration** via gsettings/dconf

## 📁 Repository Structure

```
42-setup/
├── setup-enhanced.sh        # Main setup script (NEW)
├── setup.sh                 # Original setup script
├── backup.sh                # Backup/restore utility (NEW)
├── modules/
│   ├── bash.sh              # Bash configuration (NEW)
│   ├── terminal.sh           # Terminal colors & fonts
│   ├── vim.sh                # Vim configuration
│   └── zsh.sh                # Zsh configuration
├── configs/
│   ├── .bashrc               # Your optimized bashrc (NEW)
│   ├── .zshrc                # Your optimized zshrc (NEW)
│   └── .vimrc                # Your optimized vimrc (NEW)
└── SETUP_GUIDE.md            # This guide (NEW)
```

## 🐛 Troubleshooting

### Common Issues
```bash
# If setup fails, check the log
cat ~/.42setup_enhanced.log

# If vim plugins don't load
vim +PlugInstall +qall

# If terminal colors don't work
source ~/.bashrc
# or restart terminal

# If font doesn't appear
fc-cache -f ~/.local/share/fonts
```

### Restore Previous Configuration
```bash
# List your backups
./backup.sh list

# Restore last backup
./backup.sh restore
```

### Manual Font Installation
If automatic font installation fails:
```bash
# Check the reference file
cat ~/.catppuccin-mocha-reference.conf

# Manually configure your terminal with those colors
```

## 📚 Key Command Reference

### Fast Navigation (fasd)
```bash
j <partial>     # Jump to directory (e.g., j printf)
n <partial>     # Open file in vim (e.g., n main)
```

### 42 Development
```bash
42help          # Show all available commands
42new <name>    # Create new project
ctest <file>    # Compile and test
normcheck       # Check norminette
valg <program>  # Run with valgrind
```

### Utilities
```bash
mkcd <dir>      # Create and enter directory
backup          # Backup current directory
reload          # Reload bash configuration
```

## 🌍 École 42 Campus Compatibility

This setup works on all École 42 campuses worldwide:
- 🇫🇷 Paris, Lyon, Nice
- 🇪🇸 Madrid, Barcelona
- 🇬🇧 London
- 🇩🇪 Berlin
- 🇦🇹 Vienna
- 🇧🇪 Brussels
- 🇳🇱 Amsterdam
- 🇫🇮 Helsinki
- 🇮🇹 Rome
- 🇹🇷 Istanbul
- 🇯🇵 Tokyo
- 🇰🇷 Seoul
- And many more!

## 📞 Support

- **Log file**: `~/.42setup_enhanced.log`
- **Backup directory**: Check `./backup.sh list`
- **Individual modules**: Run modules separately for debugging
- **Dry run**: Use `--dry-run` to preview changes

---

**Made for École 42 students, by École 42 students** 🎓

*Happy coding!* 🚀