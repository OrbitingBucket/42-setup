# 42 École Setup

Quick and efficient development environment setup for École 42 students worldwide.

## 🚀 Quick Install

### One-Line Setup (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup.sh | bash
```

### Configure Git (After Environment Setup)
```bash
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/git-setup.sh | bash
```

### Health Check (Verify Everything Works)
```bash
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash
```

**Total setup time: ~3 minutes**

---

## 📋 What's Included

### ✅ Environment Setup (`setup.sh`)
- **Zsh + Oh My Zsh** with useful plugins (autosuggestions, syntax highlighting)
- **Vim configuration** optimized for 42 projects and norminette
- **Directory structure** (`~/code/42`, `~/code/personal`, `~/code/tmp`)
- **42-specific aliases** and functions
- **Compilation shortcuts** with 42 flags (`-Wall -Wextra -Werror`)

### ✅ Git Configuration (`git-setup.sh`)
- **Interactive setup** for any École 42 student
- **Email validation** for proper 42 format (login@student.42city.fr)
- Useful Git aliases for 42 workflow
- **SSH key generation** for GitHub
- Line ending configuration for norminette compliance

### ✅ Health Check (`health-check.sh`)
- Comprehensive environment verification
- Tests all tools and configurations
- Provides specific fix suggestions for any issues

---

## 🔧 Manual Installation

If you prefer to inspect the scripts first:

```bash
# Clone the repository
git clone https://github.com/OrbitingBucket/42-setup.git
cd 42-setup

# Make scripts executable
chmod +x *.sh

# Run setup
./setup.sh
./git-setup.sh

# Verify installation
./health-check.sh
```

---

## ⚡ Quick Commands After Setup

### Navigation
```bash
42          # Go to ~/code/42 (projects directory)
code        # Go to ~/code (main code directory)
tmp         # Go to ~/code/tmp (temporary files)
```

### Development
```bash
cc file.c           # Compile with 42 flags (-Wall -Wextra -Werror)
ccg file.c          # Compile with debug symbols
ctest file.c        # Quick compile and test
norm file.c         # Check norminette (when installed)
valg ./program      # Run with valgrind
```

### Git Shortcuts
```bash
gs              # git status
ga .            # git add all
gc -m "msg"     # git commit with message
gp              # git push
gl              # git pull
glog            # pretty git log
gundo           # undo last commit (keep changes)
```

### Utilities
```bash
mkcd newdir     # Create directory and cd into it
backup          # Backup current directory
42new project   # Create new 42 project with Makefile
reload          # Reload shell configuration
```

---

## 📁 Repository Structure

```
42-setup/
├── setup.sh           # Main environment setup
├── git-setup.sh       # Git configuration (interactive for any 42 student)
├── health-check.sh    # Environment verification
├── .vimrc            # Vim configuration with 42 optimizations
├── .zshrc            # Zsh configuration and 42 functions
└── README.md         # This guide
```

---

## 🎯 42-Specific Features

### Vim Configuration
- **Line limit highlighting** at 80 characters (norminette requirement)
- **Trailing whitespace** removal on save
- **42 header template** function (`<leader>h`)
- **Quick compilation** (`<leader>cc`) and norm check (`<leader>cn`)
- **Your custom key bindings** (Alt+Enter, Ctrl+End, etc.)

### Zsh Functions
- **`42new <project>`** - Creates new project with proper Makefile
- **`ctest file.c`** - Compile, run, and cleanup in one command
- **`normcheck`** - Enhanced norminette checking
- **`gcom "message"`** - Git add all + commit
- **`gacp "message"`** - Git add all + commit + push

### Development Workflow
- **Automatic norminette compliance** (whitespace, line endings)
- **42 compilation flags** as default
- **Project templates** with proper 42 headers
- **Git workflow** optimized for 42 submission process

---

## 🔍 Troubleshooting

### If setup fails:
```bash
# Run health check to see what's missing
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash
```

### Common issues:
- **Permission denied**: Some schools restrict `chsh` command (shell change)
- **Git not configured**: Run the git-setup script separately
- **Norminette not found**: Install when you need it from 42 intranet
- **SSH key issues**: Follow the GitHub setup instructions in git-setup

### Reset configuration:
```bash
# Backup and reset if needed
mv ~/.vimrc ~/.vimrc.backup
mv ~/.zshrc ~/.zshrc.backup
mv ~/.42_aliases ~/.42_aliases.backup

# Re-run setup
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup.sh | bash
```

---

## 🌍 École 42 Worldwide

### Supports all 42 campuses:
- **Paris, France** 🇫🇷
- **Madrid, Spain** 🇪🇸
- **Barcelona, Spain** 🇪🇸
- **London, UK** 🇬🇧
- **Berlin, Germany** 🇩🇪
- **Vienna, Austria** 🇦🇹
- **Brussels, Belgium** 🇧🇪
- **Amsterdam, Netherlands** 🇳🇱
- **Helsinki, Finland** 🇫🇮
- **Rome, Italy** 🇮🇹
- **Istanbul, Turkey** 🇹🇷
- **Tokyo, Japan** 🇯🇵
- **Seoul, South Korea** 🇰🇷
- **And many more!**

### Email format examples:
- `jdoe@student.42paris.fr`
- `jdoe@student.42madrid.fr`
- `jdoe@student.42london.fr`
- `jdoe@student.42berlin.fr`

### Features:
- **Automatic email validation** for proper 42 format
- **Campus-agnostic setup** works everywhere
- **Multi-language support** (English interface)
- **Norminette compliance** for all campuses
- **Universal Git workflow** for 42 projects

---

## 🤝 Contributing

This setup is designed for all École 42 students worldwide. To contribute:

1. Fork the repository
2. Make your improvements
3. Test on different 42 campuses if possible
4. Submit a pull request
5. Help fellow 42 students! 🎓

### Ideas for contributions:
- Support for additional text editors (emacs, nano)
- More shell options (fish, bash customizations)
- Additional 42-specific tools and aliases
- Campus-specific optimizations
- Multi-language documentation

---

## 📄 License

Free to use and modify for all École 42 students worldwide.

---

**Happy coding at École 42! 🌍🎓**

*Made by 42 students, for 42 students.*
