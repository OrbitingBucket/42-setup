📋 42 École Setup Script - Implementation Plan

  🎯 Project Structure

  42-setup/
  ├── setup.sh              # Main entry point
  ├── modules/
  │   ├── terminal.sh        # Terminal colors & fonts
  │   ├── vim.sh            # Vim configuration & plugins
  │   └── zsh.sh            # Zsh + Oh My Zsh setup
  ├── configs/
  │   ├── .vimrc            # Clean vim config
  │   ├── .zshrc            # Zsh configuration
  │   └── terminal-colors.conf # Terminal color scheme
  ├── tests/
  │   └── verify.sh         # Post-install verification
  └── README.md             # Installation & usage guide

  ---
  🚀 Phase 1: Main Setup Script (setup.sh)

  Purpose:

  - Entry point that orchestrates everything
  - No elevated permissions required
  - Error handling and rollback
  - Progress reporting

  Features:

  #!/bin/bash
  # 42 École Environment Setup
  # Usage: curl -sSL https://raw.githubusercontent.com/USER/42-setup/main/setup.sh | bash

  # 1. Environment detection (42 school vs other)
  # 2. Create directory structure (~/code/{42,personal,tmp})
  # 3. Call individual module scripts
  # 4. Run verification tests
  # 5. Provide usage instructions

  Key Requirements:

  - ✅ No sudo or chsh commands
  - ✅ Backup existing configs
  - ✅ Modular design (can run individual parts)
  - ✅ Progress indicators
  - ✅ Error recovery

  ---
  🖥️ Phase 2: Terminal Module (modules/terminal.sh)

  Purpose:

  Configure terminal colors, fonts, and environment variables

  Features:

  1. Install JetBrains Mono Nerd Font
  # Download to ~/.local/share/fonts/
  # Update font cache
  # No system-wide installation
  2. Apply Catppuccin Mocha Color Scheme
  # GNOME Terminal profile configuration
  # Set 16-color palette with proper bright variants
  # Configure background/foreground colors
  3. Environment Variables
  export TERM=xterm-256color
  export COLORTERM=truecolor
  # Add to ~/.bashrc and ~/.zshrc

  Color Palette (Fixed):

  # Using your working home machine palette
  PALETTE="['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#a6adc8', '#585b70', '#f37799', '#89d88b', '#ebd391', '#74a8fc', '#f2aede', '#6bd7ca', 
  '#bac2de']"

  ---
  📝 Phase 3: Vim Module (modules/vim.sh)

  Purpose:

  Set up enhanced Vim with NvChad-like features

  Features:

  1. Plugin Manager (vim-plug)
  # Auto-install vim-plug
  # No manual intervention required
  2. Essential Plugins:
  Plug 'catppuccin/vim'              " Official Catppuccin theme
  Plug 'preservim/nerdtree'          " File explorer
  Plug 'itchyny/lightline.vim'       " Status line  
  Plug 'jiangmiao/auto-pairs'        " Auto-close brackets
  Plug 'tpope/vim-surround'          " Text surround
  Plug 'preservim/nerdcommenter'     " Smart commenting
  Plug 'sheerun/vim-polyglot'        " Syntax highlighting
  3. 42-Specific Configuration:
  " Line limit highlighting (80 chars)
  " Norminette compliance settings
  " Custom key bindings for 42 workflow
  " Compilation shortcuts
  4. Key Bindings:
  let mapleader = " "
  " <space>h - Toggle horizontal terminal (bottom)
  " <space>e - Toggle file tree
  " <space>/ - Toggle comments
  " <space>cc - Compile C file
  " <space>cn - Check norminette

  Terminal Integration:

  " Simple, reliable terminal toggle
  function! ToggleBottomTerminal()
      " Open at bottom, 12 lines height
      " Close with same key
      " No external dependencies
  endfunction

  ---
  🐚 Phase 4: Zsh Module (modules/zsh.sh)

  Purpose:

  Configure Zsh with Oh My Zsh (manual activation, no shell change)

  Features:

  1. Oh My Zsh Installation
  # Install if not present
  # Configure plugins: git, zsh-autosuggestions, zsh-syntax-highlighting
  # Set theme: robbyrussell (reliable)
  2. 42-Specific Functions:
  42new() { ... }          # Create new 42 project with Makefile
  ctest() { ... }          # Compile and test C files
  normcheck() { ... }      # Enhanced norminette checking
  gcom() { ... }           # Git add + commit
  gacp() { ... }           # Git add + commit + push
  3. Aliases:
  alias 42='cd ~/code/42'
  alias code='cd ~/code'
  alias cc='gcc -Wall -Wextra -Werror'
  alias norm='norminette'
  alias gs='git status'
  4. History Configuration:
  HISTSIZE=100000
  SAVEHIST=100000
  # Shared history, timestamps, deduplication
  5. Color Configuration:
  # Colored prompt
  # Syntax highlighting
  # Autosuggestions styling

  Activation:

  # No automatic shell change
  # User types 'zsh' to activate
  # Add instruction to use zsh manually

  ---
  ✅ Phase 5: Verification Module (tests/verify.sh)

  Purpose:

  Comprehensive testing of all components

  Tests:

  1. Terminal Colors:
  # Check TERM variable
  # Verify 256 color support
  # Test true color rendering
  2. Vim Configuration:
  # Plugin installation status
  # Colorscheme loading
  # Key binding functionality
  # 42-specific features
  3. Zsh Setup:
  # Oh My Zsh installation
  # Plugin availability
  # Function definitions
  # History configuration

  Output:

  🧪 42 École Environment Verification
  ===================================
  ✅ Terminal: Colors working, font installed
  ✅ Vim: Plugins loaded, theme active
  ✅ Zsh: Available with 'zsh' command
  ✅ All systems ready for École 42!

  ---
  🎯 Usage Scenarios

  Complete Setup:

  # Clone and run everything
  git clone https://github.com/OrbitingBucket/42-setup.git
  cd 42-setup
  ./setup.sh

  Individual Components:

  # Just vim setup
  ./modules/vim.sh

  # Just terminal colors
  ./modules/terminal.sh

  # Just zsh configuration
  ./modules/zsh.sh

  One-liner (École 42 machines):

  curl -sSL https://raw.githubusercontent.com/OrbitingBucket/42-setup/main/setup.sh | bash

  ---
  🔧 Implementation Timeline

  1. ✅ Create modular structure
  2. ✅ Implement terminal module (colors, fonts)
  3. ✅ Implement vim module (plugins, theme, bindings)
  4. ✅ Implement zsh module (oh-my-zsh, functions, aliases)
  5. ✅ Create verification tests
  6. ✅ Write comprehensive documentation
  7. ✅ Test on École 42 environment

  ---
  💡 Key Design Principles

  - 🔒 No elevated permissions - Works on restricted École 42 machines
  - 🎯 Modular design - Can install components separately
  - 🛡️ Safe defaults - Backups existing configs
  - 🎨 Consistent theming - Catppuccin everywhere
  - ⚡ École 42 optimized - Norminette, 42 functions, project structure
