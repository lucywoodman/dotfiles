# .dotfiles

Personal dotfiles for macOS development environment setup using [Task](https://taskfile.dev).

## Prerequisites

- macOS with Homebrew [Homebrew](https://brew.sh)
- [Task](https://taskfile.dev) (`brew install go-task`)
- 1Password (for SSH and private configs)

## Installation

```bash
git clone git@github.com:lucywoodman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
task bootstrap
```

Restart your terminal when complete.

## Structure

```
dotconfig/       # XDG-compliant app configurations
├── zsh/         # Shell customisations (aliases, exports, functions)
├── git/         # Git configurations
├── nvim/        # Neovim editor config
├── aerospace/   # Tiling window manager config
├── claude/      # Claude Code skills and settings
├── mise/        # Runtime version manager config
├── starship.toml
├── dprint.json
└── editorconfig
.private         # Private configs (not version controlled)
macos/           # macOS system settings
Taskfile.yml     # Task runner configuration
Brewfile         # Homebrew package management
```

## Key Features

- **Modern CLI tools**: `bat`, `lsd`, `fzf`, `zoxide`, `ripgrep`, `fd`, `jq`, `delta`
- **Shell**: zsh with Oh-My-Zsh, Starship prompt, XDG-compliant configuration
- **Development stack**: `mise` for version management (Node, Python, Go, Terraform, Kubernetes tools), PHP via Homebrew
- **Productivity apps**: 1Password, Alfred, Obsidian, AeroSpace, Ghostty
- **Development tools**: Claude Code, Neovim
- **1Password integration**: SSH agent and CLI tools authentication

## Task Commands

```bash
task              # List all available tasks
task bootstrap    # Complete setup (directories, oh-my-zsh, symlinks, brew)
task symlinks     # Create all symlinks
task brew         # Install/update Homebrew packages
task check        # Verify symlink configuration
task macos        # Apply macOS system settings
task unlink       # Remove all symlinks (use with caution)
```

## Private Configuration

Store sensitive configs in `.private/`:

- `~/.private/private.aliases` - Private shell aliases
- `~/.private/private.exports` - Private environment variables

The private directory is symlinked to `~/.private` and sourced automatically by zsh.

## Maintenance

```bash
# Update packages
brew update && brew upgrade
brew cu                        # Update GUI apps (requires buo/cask-upgrade tap)

# Update dotfiles
cd ~/.dotfiles
git pull
task bootstrap

# Check configuration
task check
```

## XDG Base Directory Compliance

This setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/).

## Design Principles

- Simple over complex
- Only tools actually used
- XDG-compliant where possible
- Task-based automation
- Modular configuration
