# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS that automates development environment setup using **dotbot** as the installation framework. The repository manages shell configurations, git settings, package installations, and macOS system preferences.

## Installation & Setup Commands

### Initial Setup
```bash
# Full dotfiles installation
./install

# Individual components (run from repo root)
./dotbot/bin/dotbot -d . --plugin-dir dotbot-brewfile -c install.yml
./scripts/install-webi.sh
```

### Maintenance Commands
```bash
# Update packages
brew update && brew upgrade

# Install/update webi packages
./scripts/install-webi.sh

# Update Oh My Zsh
omz update

# Update dotfiles repository
git pull && ./install

# Check outdated GUI apps
brew cu

# Apply macOS settings
macos/settings.sh

# Clean Claude Code chat history (reduces ~/.claude.json file size)
claude-cleanup
```

## Architecture

### Core Components
- **dotbot**: Installation automation using YAML config in `install.yml`
- **Brewfile**: Package management for CLI tools and GUI applications
- **Webifile**: Package management for modern CLI tools via webinstall.dev
- **Shell configs**: Modular zsh setup with Oh-My-Zsh
- **Private configs**: Sensitive settings stored in 1Password

### Directory Structure
```
├── config/          # App configuration files (git, helix, etc.)
├── shell/           # Shell customizations (.aliases, .exports, etc.)
├── scripts/         # Installation and maintenance scripts
├── macos/           # macOS system preference scripts
├── dotbot/          # Dotbot submodule
├── dotbot-brewfile/ # Homebrew plugin for dotbot
├── Brewfile         # Homebrew package definitions
└── Webifile         # Webi package definitions
```

### Installation Flow
1. **Directories**: Creates `~/notes`, `~/workspace`, `~/.private`
2. **Terminal**: Installs Oh-My-Zsh, symlinks shell and app configs
3. **Dependencies**: Installs packages via Brewfile (Homebrew)
4. **Webi packages**: Installs modern CLI tools via Webifile (webinstall.dev)

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

### Git Aliases (in gitconfig)
- `git publish` - Push current branch to origin with upstream
- `git main` - Switch to main/master branch
- `git prune-branches` - Remove local branches that are gone from remote
- `git patch` - Show diff without pager

### Modern CLI Tools
- `ll` - Enhanced ls with directories first (uses lsd)
- `cat` - Syntax highlighted cat (uses bat)
- `k8` - kubectl alias

## Private Configuration

Some files contain sensitive information and are stored in 1Password:
- `~/.private/private.aliases` - Private shell aliases
- `~/.private/private.exports` - Private environment variables  
- `~/.gitconfig_local` - Private git configuration

These are loaded automatically if they exist but are not tracked in git.

## Package Management

### Homebrew (Brewfile)
Core packages for system services and GUI applications:
- **CLI Tools**: htop, zoxide
- **Development**: Docker, Helix, direnv, dprint
- **Language Tools**: PHP, Node.js, AWS CLI
- **Databases**: PostgreSQL, MySQL
- **GUI Apps**: 1Password, Alfred, Arc, Obsidian, Rectangle
- **Mac App Store**: Things 3, Dato, HazeOver

### Webi (Webifile)
Modern CLI tools installed via webinstall.dev:
- **Core Tools**: bat (syntax highlighting), lsd (modern ls), fzf (fuzzy finder)
- **Git Tools**: gh (GitHub CLI), delta (enhanced diff viewer)
- **Development**: jq (JSON processor)
- **Kubernetes**: k9s (TUI), kubectx/kubens (context switching)
- **Infrastructure**: terraform (IaC)

## Git Configuration

- **GPG signing**: All commits are signed
- **Delta pager**: Enhanced diff viewing with syntax highlighting
- **Auto-rebase**: Pull requests use rebase by default
- **Branch pruning**: Automatic cleanup of stale references

## Shell Environment

- **Zsh with Oh-My-Zsh**: Uses gitfast and gh plugins
- **zplug**: Additional plugin management
- **Modular configs**: Separated into .aliases, .exports, .external, .completions
- **Version managers**: nvm (Node.js), support for chruby (Ruby), rye (Python)

## Development Tools

- **Terminal**: Ghostty for terminal emulation
- **Editor**: Helix text editor with custom configuration
- **Containers**: Docker with compose aliases
- **Cloud**: AWS CLI, Kubernetes tools (k9s, kubectx, kubens)
- **Version Control**: Git with delta pager, GitHub CLI (gh)

## Claude Code Integration

This repository includes custom agents and slash commands for enhanced Claude Code workflows:

### AI Agents (in `config/claude/agents/`)
- **code-reviewer**: Sandy Metz-style code reviews with educational feedback
- **debug-reasoner**: Teaching-focused debugging with systematic hypothesis testing
- **design-reviewer**: Architectural analysis using Fowler/Hickey/Uncle Bob perspectives
- **commit-message-writer**: Conventional commit message generation
- **php-pro**: Advanced PHP development patterns and best practices

### Slash Commands (in `config/claude/commands/`)
- `/review <PR#>` - Launch code-reviewer agent for pull request analysis
- `/debug <target>` - Launch debug-reasoner agent for systematic problem-solving
- `/design <target>` - Launch design-reviewer agent for architectural evaluation
- `/analyse <target>` - Comprehensive problem analysis workflow
- `/create-pr` - Pull request creation workflow
- `/commit-changes` - Structured commit process

### Custom Statusline
- Shows current repository and git branch: `📁 repo-name | 🌿 branch-name`
- Script located at `config/claude/statusline.sh`

## Important Notes

- Requires macOS with Homebrew pre-installed
- 1Password integration for SSH agent and private configs
- All configurations are symlinked, not copied
- System preferences are applied via macos/settings.sh script
- Git submodules are used for dotbot and plugins
- Claude Code agents provide autonomous reasoning and contextual analysis