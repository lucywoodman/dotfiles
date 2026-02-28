#!/usr/bin/env bash

# `.exports` is used to provide custom environment variables.

# ═══════════════════════════════════════════════════════════════════════════
# Path Management
# ═══════════════════════════════════════════════════════════════════════════

# Helper function to add directories to PATH without duplicates
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Add project-specific binaries (still useful for development)
add_to_path "vendor/bin"                # Project-specific PHP dependencies
add_to_path "node_modules/.bin"         # Project-specific Node modules

# Composer global binaries (phpcs, etc.)
add_to_path "$HOME/.config/composer/vendor/bin"

# MySQL client tools (installed as keg-only by Homebrew)
add_to_path "/opt/homebrew/opt/mysql@8.4/bin"

# Obsidian CLI (enabled via Obsidian settings)
add_to_path "/Applications/Obsidian.app/Contents/MacOS"

# ═══════════════════════════════════════════════════════════════════════════
# Homebrew Configuration
# ═══════════════════════════════════════════════════════════════════════════

export HOMEBREW_NO_ANALYTICS=1          # Disable Homebrew telemetry

# ═══════════════════════════════════════════════════════════════════════════
# Pager Configuration
# ═══════════════════════════════════════════════════════════════════════════

# less options:
#   -i  smart case-insensitive search
#   -R  color support
#   -F  exit if content fits on one screen
#   -X  don't clear screen on exit
#   -M  verbose prompt with position
#   -x4 tabs are 4 spaces
export LESS='-iRFXMx4'
export PAGER='less'

# ═══════════════════════════════════════════════════════════════════════════
# Development Tool Histories
# ═══════════════════════════════════════════════════════════════════════════

# Node.js REPL history
export NODE_REPL_HISTORY="$HOME/.node_history"
export NODE_REPL_MODE='sloppy'          # Match web browser behavior

# ═══════════════════════════════════════════════════════════════════════════
# Syntax Highlighting Configuration
# ═══════════════════════════════════════════════════════════════════════════

# Limit zsh-syntax-highlighting to 200 chars for performance
export ZSH_HIGHLIGHT_MAXLENGTH=200

# ═══════════════════════════════════════════════════════════════════════════
# Private Exports
# ═══════════════════════════════════════════════════════════════════════════

# Load private/sensitive exports if they exist
[ -f "$HOME/.private/private.exports" ] && source "$HOME/.private/private.exports"

# ═══════════════════════════════════════════════════════════════════════════
# Finalize PATH
# ═══════════════════════════════════════════════════════════════════════════

# Export PATH (should be last)
export PATH
