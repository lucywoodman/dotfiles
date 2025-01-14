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

## Configuration Structure

```
dotfiles/
├── config/          # Configuration files
├── shell/           # Shell customizations
├── steps/           # Installation steps
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

### Visual Studio Code
1. Install Visual Studio Code through the Brewfile
2. Set up settings sync through GitHub account

### Obsidian
1. Install Obsidian through the Brewfile
2. Clone your Obsidian vault if needed:
```bash
git clone https://github.com/yourusername/obsidian-wiki ~/Notes
```

## Components

- **Terminal**: Uses Alacritty with Oh My Zsh and custom configurations
- **Shell**: Custom aliases, exports, and functions
- **Git**: Global configurations and attributes
- **macOS**: System preferences and defaults
- **Package Management**: Homebrew with Brewfile for dependencies

## Maintenance

- Update packages: `brew update && brew upgrade`
- Update Oh My Zsh: `omz update`
- Update repository: `git pull && ./install`

## Contributing

Feel free to fork this repository and customize it for your own use. Pull requests for improvements are welcome!

## License

This project is free to use and distribute. Feel free to fork and modify as needed.

