# .dotfiles

My personal dotfiles for macOS system configuration and development environment setup. This repository uses [dotbot](https://github.com/anishathalye/dotbot) for installation management and is inspired by [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles) and [Nikita Sobolev's dotfiles](https://github.com/sobolevn/dotfiles).

## Prerequisites

- macOS
- 1Password (for SSH and private configurations)
- Homebrew

## Initial Setup

### 1. Install Homebrew
```bash
# Check if Homebrew is installed
which brew

# If not installed, install it from https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to your PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
source $HOME/.zprofile
```

### 2. Set up 1Password & SSH
```bash
# Install 1Password
brew update
brew install --cask 1Password
```

1. Set up 1Password and enable SSH agent
2. Verify SSH setup with GitHub:
```bash
ssh -T git@github.com
```

### 3. Install Dotfiles

1. Clone this repository:
```bash
git clone git@github.com:lucywoodman/dotfiles.git
cd dotfiles
```

2. Run the installation:
```bash
./install
```

## Key Aliases & Commands

### Navigation
- `dotfiles` - cd to ~/.dotfiles
- `workspace` - cd to ~/workspace  
- `notes` - cd to ~/notes

### Docker
- `dcu` - docker compose up -d
- `dcd` - docker compose down
- `dcdc` - docker compose down --remove-orphans -v
- `dcr` - docker compose restart
- `dcb` - docker compose build
- `dcl` - docker compose logs -f

### Git & GitHub
- `ghpr <pr_number>` - Copy GitHub PR URL to clipboard
- Git aliases via gitconfig for enhanced workflow

### Modern CLI Tools
- `ll` - Enhanced ls with directories first (uses lsd/eza)
- Modern replacements: `bat` (cat), `fzf` (fuzzy finder), `hexyl` (hex viewer)

### Claude Code
- `claude` - Local Claude Code installation
- `claude-cleanup` - Clean chat history to reduce file size

## Enhanced Installation Options

The install script supports several advanced options for different use cases:

### System Compatibility Check
Before installation, check if your system is compatible:
```bash
./scripts/system-info --compatibility
```

### Safe Installation with Backup
Create a backup of existing configurations before installation:
```bash
./install --backup
```

### Unattended Installation
For automation, CI/CD, or scripted setups:
```bash
./install --auto-yes
```

### Combined Options
Backup and install without prompts:
```bash
./install --backup --auto-yes
```

### System Information
Get comprehensive system information and environment analysis:
```bash
./scripts/system-info              # Full system information
./scripts/system-info --xdg        # XDG directory compliance
./scripts/system-info --env        # Environment analysis
```

## Configuration Structure

```
dotfiles/
├── config/          # Configuration files
│   ├── claude/      # Claude Code configuration
│   └── ...          # Other app configs
├── shell/           # Shell customizations
│   ├── commands/    # Shell utility functions
│   └── ...          # Aliases, exports, etc.
├── steps/           # Installation steps
├── scripts/         # Utility scripts
└── macos/           # macOS specific settings
```

## Private Configurations

Some configurations contain sensitive information and are stored separately in 1Password. After installation:

1. Retrieve these files from 1Password and place them in the correct locations:
   - `private.aliases` → `$HOME/.private/private.aliases`
   - `private.exports` → `$HOME/.private/private.exports`
   - `.gitconfig_local` → `$HOME/.gitconfig_local`

## Additional Setup

### Alfred Preferences
If you use Alfred:
1. Install Alfred through the Brewfile
2. Set up your Alfred preferences sync

### Claude Code
Claude Code is configured with local installation, AI agents, and custom workflows:
1. Local installation available via `claude` alias
2. **AI Agents** for autonomous code analysis:
   - `/review` - Sandy Metz-style code reviews with educational feedback
   - `/debug` - Teaching-focused debugging with systematic hypothesis testing
   - `/design` - Architectural analysis using expert perspectives (Fowler/Hickey/Uncle Bob)
3. **Custom Commands** for development workflow in `config/claude/commands/`
4. **Statusline** showing current repo and git branch
5. Chat history cleanup utility: `claude-cleanup`

### Obsidian
1. Install Obsidian through the Brewfile
2. Clone your Obsidian vault if needed:
```bash
git clone https://github.com/yourusername/obsidian-wiki ~/Notes
```

## Package Overview

The Brewfile manages 60+ packages organized by category:

### CLI Tools
- **Core**: `bat`, `eza`, `fzf`, `tree`, `tmux`, `zellij`, `zoxide`
- **Git**: `git`, `gh`, `git-delta`, `pre-commit`, `tig`
- **Development**: `helix`, `hexyl`, `jq`, `direnv`, `nvm`
- **Cloud**: `awscli`, `kubectl`, `kubectx`

### GUI Applications
- **Development**: Docker Desktop, Ghostty
- **Productivity**: 1Password, Alfred, Arc, Obsidian, Rectangle
- **Mac App Store**: Things 3, Dato, HazeOver, Hand Mirror, Boop

## Components

- **Terminal**: Uses Ghostty with Oh My Zsh and custom configurations
- **Shell**: Custom aliases, exports, and functions
- **Git**: Global configurations and attributes
- **macOS**: System preferences and defaults
- **Package Management**: Homebrew with Brewfile for dependencies
- **Claude Code**: Local installation and configuration management
- **Development Tools**: Helix editor, Docker Desktop, Git utilities

## Maintenance

- Update packages: `brew update && brew upgrade`
- Update GUI apps: `brew cu`
- Update Oh My Zsh: `omz update`
- Update repository: `git pull && ./install`
- Clean Claude Code chat history: `claude-cleanup`

## Contributing

Feel free to fork this repository and customize it for your own use. Pull requests for improvements are welcome!

## License

This project is free to use and distribute. Feel free to fork and modify as needed.

