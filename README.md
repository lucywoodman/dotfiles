# .dotfiles

Personal dotfiles for macOS development environment setup using [dotbot](https://github.com/anishathalye/dotbot).

## Prerequisites

- macOS with Homebrew
- 1Password (for SSH and private configs)

## Installation

```bash
git clone git@github.com:lucywoodman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

Restart your terminal when complete.

## Structure

```
config/          # App configurations (git, helix, claude, etc.)
shell/           # Shell customizations (.aliases, .exports, .functions, etc.)
scripts/         # Installation and maintenance scripts
macos/           # macOS system settings
install.yml      # Dotbot configuration
Brewfile         # Homebrew package management
Webifile         # Webi package management
```

## Key Features

- **Modern CLI tools**: `bat`, `lsd`, `fzf`, `zoxide`, `htop`, `shellcheck`
- **Shell functions**: `list_functions` to see all available
- **Development stack**: PHP, Node.js, Python, Docker, Kubernetes, Terraform
- **Productivity apps**: 1Password, Alfred, Arc, Obsidian, Rectangle

## Private Configuration

Store sensitive configs in 1Password:

- `~/.private/private.aliases`
- `~/.private/private.exports`
- `~/.gitconfig_local`

## Maintenance

```bash
brew update && brew upgrade    # Update packages
./scripts/install-webi.sh      # Update webi packages
brew cu                        # Update GUI apps
git pull && ./install          # Update dotfiles
```

## Design Principles

- Simple over complex
- Only tools actually used
- Git provides backup/sync
- Modular shell configuration
