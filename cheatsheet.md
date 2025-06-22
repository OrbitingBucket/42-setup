# 🎓 42 École Development Environment Cheatsheet

Complete reference for your enhanced Vim + Zsh + Oh My Zsh setup with NvChad-like features.

---

## 🔑 Vim Key Bindings

### Basic Navigation & Editing
| Key | Action |
|-----|--------|
| `jk` | Quick escape from insert mode (custom) |
| `;` | Enter command mode (`:` equivalent) |
| `W` | Quick save (capital W) |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>Q` | Force quit |
| `<leader>/` | Clear search highlighting |

**Leader key = Spacebar**

### 🎨 Custom Movement Bindings
| Key | Action |
|-----|--------|
| `Alt+Enter` | Jump to matching `}` and open new line |
| `Ctrl+End` | Jump to end of file and open new line |
| `Alt+j` | Move current line down |
| `Alt+k` | Move current line up |

### 📁 File Explorer (NERDTree)
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file tree on/off |
| `<leader>f` | Find current file in tree |

**Inside NERDTree:**
| Key | Action |
|-----|--------|
| `o` | Open file/folder |
| `t` | Open in new tab |
| `s` | Open in vertical split |
| `i` | Open in horizontal split |
| `m` | Show menu (create/delete/rename files) |
| `R` | Refresh tree |
| `?` | Show help |

### 💻 Terminal (Neoterm)
| Key | Action |
|-----|--------|
| `<leader>t` | Open terminal in horizontal split |
| `<leader>th` | Open terminal in horizontal split |
| `<leader>tv` | Open terminal in vertical split |
| `<leader>tx` | Close terminal window (from inside terminal) |

### 📑 Buffer Management
| Key | Action |
|-----|--------|
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Delete current buffer |
| `<leader>ba` | Delete all buffers |

### 💬 Comments (NERDCommenter)
| Key | Action |
|-----|--------|
| `<leader>/` | Toggle comment on current line |
| `<leader>/` | Toggle comment on selected text (visual mode) |

### 🎯 Text Objects (Delete/Change/Yank)
| Key | Action |
|-----|--------|
| `di{` | Delete inside `{ }` (contents only) |
| `da{` | Delete around `{ }` (including braces) |
| `di(` | Delete inside `( )` |
| `da(` | Delete around `( )` |
| `di[` | Delete inside `[ ]` |
| `da[` | Delete around `[ ]` |
| `di"` | Delete inside `" "` |
| `da"` | Delete around `" "` (including quotes) |
| `di'` | Delete inside `' '` |
| `da'` | Delete around `' '` |
| `diw` | Delete inside word |
| `daw` | Delete around word (includes spaces) |
| `ci{` | Change inside `{ }` (delete + insert mode) |
| `ca{` | Change around `{ }` (delete + insert mode) |
| `yi{` | Yank (copy) inside `{ }` |
| `ya{` | Yank (copy) around `{ }` |
| `vi{` | Visual select inside `{ }` |
| `va{` | Visual select around `{ }` |

### ✨ Surround Plugin
| Key | Action |
|-----|--------|
| `cs"'` | Change `"word"` to `'word'` |
| `ds"` | Delete surrounding quotes |
| `ysiw"` | Surround word with quotes |
| `yss)` | Surround entire line with parentheses |

### 🖥️ Window Management
| Key | Action |
|-----|--------|
| `Ctrl+h` | Move to left split |
| `Ctrl+j` | Move to split below |
| `Ctrl+k` | Move to split above |
| `Ctrl+l` | Move to right split |
| `Ctrl+↑` | Resize horizontal split up |
| `Ctrl+↓` | Resize horizontal split down |
| `Ctrl+←` | Resize vertical split left |
| `Ctrl+→` | Resize vertical split right |

### 🔧 42-Specific Functions
| Key | Action |
|-----|--------|
| `<leader>cc` | Compile current C file with 42 flags |
| `<leader>cn` | Run norminette check |
| `<leader>ev` | Edit .vimrc |
| `<leader>sv` | Reload .vimrc |

### 🔌 Plugin Management
| Key | Action |
|-----|--------|
| `<leader>pi` | Install plugins |
| `<leader>pu` | Update plugins |
| `<leader>pc` | Clean unused plugins |

---

## ⌨️ Zsh + Oh My Zsh Key Bindings

### 🔍 History & Search
| Key | Action |
|-----|--------|
| `Ctrl+R` | Interactive history search (fuzzy) |
| `↑` / `Ctrl+P` | History substring search up |
| `↓` / `Ctrl+N` | History substring search down |
| `Alt+.` | Insert last argument from previous command |

### ✂️ Line Editing
| Key | Action |
|-----|--------|
| `Ctrl+A` | Move to beginning of line |
| `Ctrl+E` | Move to end of line |
| `Ctrl+U` | Delete entire line |
| `Ctrl+W` | Delete word backwards |
| `Ctrl+K` | Delete from cursor to end of line |
| `Home` | Move to beginning of line |
| `End` | Move to end of line |

### 📁 Directory Navigation
| Key | Action |
|-----|--------|
| `d` | Show directory stack (numbered list) |
| `1-9` | Jump to directory by number from stack |
| `..` | Go up one directory |
| `...` | Go up two directories |
| `....` | Go up three directories |

### ⚡ Auto-completion & Suggestions
| Key | Action |
|-----|--------|
| `Tab` | Smart completion with menu |
| `Tab Tab` | Cycle through completions |
| `Ctrl+Space` | Accept autosuggestion |
| `→` | Accept autosuggestion character by character |

---

## 🚀 42 Custom Commands & Aliases

### 📁 Navigation Shortcuts
| Command | Action |
|---------|--------|
| `42` | Go to `~/code/42` (projects directory) |
| `code` | Go to `~/code` (main code directory) |
| `tmp` | Go to `~/code/tmp` (temporary files) |
| `mkcd newdir` | Create directory and cd into it |
| `reload` | Reload shell configuration |

### 🔨 Development Tools
| Command | Action |
|---------|--------|
| `cc file.c` | Compile with 42 flags (`-Wall -Wextra -Werror`) |
| `ccg file.c` | Compile with debug symbols |
| `ctest file.c` | Quick compile, run, and cleanup |
| `norm file.c` | Check norminette (alias for norminette) |
| `valg ./program` | Run with valgrind |

### 📝 Git Shortcuts (Oh My Zsh)
| Command | Action |
|---------|--------|
| `gs` | `git status` |
| `ga .` | `git add all` |
| `gc -m "msg"` | `git commit with message` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `glog` | Pretty git log |
| `gundo` | Undo last commit (keep changes) |

### 🎯 42 Custom Functions
| Command | Action |
|---------|--------|
| `42new <project>` | Create new 42 project with Makefile |
| `gcom "message"` | Git add all + commit |
| `gacp "message"` | Git add all + commit + push |
| `normcheck [file]` | Enhanced norminette checking |
| `backup_project` | Backup current directory as tar.gz |

### 🔧 System Utilities
| Command | Action |
|---------|--------|
| `sudo !!` | Re-run last command with sudo |
| `z dirname` | Jump to frequently used directory (z plugin) |

---

## 🎨 Theme & Colors

### Terminal Colors
- **Background:** `#1e1e2e` (Catppuccin Base)
- **Foreground:** `#cdd6f4` (Catppuccin Text)
- **Font:** JetBrainsMono Nerd Font 12pt
- **Palette:** Full Catppuccin Mocha with 16-color support

### Vim Color Scheme
- **Theme:** Custom Catppuccin Mocha implementation
- **Features:** 
  - Syntax highlighting for 200+ languages
  - Rainbow parentheses with Catppuccin colors
  - Matching terminal and editor colors
  - True color support (`termguicolors`)

---

## 🔧 Configuration Files

### Key Files
| File | Purpose |
|------|---------|
| `~/.vimrc` | Vim configuration with plugins |
| `~/.zshrc` | Zsh + Oh My Zsh configuration |
| `~/.42_aliases` | 42-specific aliases and functions |
| `~/.vim/plugged/` | Vim plugins directory |

### History Configuration
- **Zsh:** 100,000 commands with timestamps
- **Bash:** 100,000 commands with timestamps
- **Features:** Duplicate removal, session sharing, smart ignore

---

## 🛠️ Maintenance Commands

### Plugin Updates
```bash
# Vim plugins
vim +PlugUpdate +qall

# Oh My Zsh
omz update
```

### Setup Scripts
```bash
# Main environment setup
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup.sh | bash

# Git configuration
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/git-setup.sh | bash

# Terminal colors
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/terminal-colors.sh | bash

# History configuration
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/history-config.sh | bash

# Health check
curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/health-check.sh | bash
```

---

## 💡 Tips & Tricks

### Vim Tips
- Use `.` to repeat last action
- Use `*` to search for word under cursor
- Use `:%s/old/new/g` for global search and replace
- Use `:w !sudo tee %` to save file with sudo
- Use `Ctrl+v` for visual block mode (column selection)

### Zsh Tips
- Type directory name without `cd` to navigate
- Use `!!` to repeat last command
- Use `!$` to get last argument of previous command
- Use `Ctrl+x Ctrl+e` to edit command in vim
- Use `history | grep <term>` to search command history

### 42-Specific Tips
- Use `42new <project>` for instant project setup
- Use `ctest file.c` for quick compile-test cycles
- Use `normcheck` before submitting projects
- Keep projects in `~/code/42/` for organization
- Use `backup_project` before major changes

---

**Made with ❤️ for École 42 students worldwide** 🌍🎓

*For issues or improvements: https://github.com/OrbitingBucket/42-setup*