#!/usr/bin/env bash
# ABOUTME: Install packages listed in Webifile using webi
# ABOUTME: Run from dotfiles root: ./scripts/install-webi.sh

set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing webi packages..."

# Install webi if not available
if ! command -v webi >/dev/null 2>&1; then
    echo "Installing webi..."
    curl -sS https://webi.sh/webi | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Extract package names from Webifile (ignore comments and empty lines)
packages=$(grep -v '^#' "$BASEDIR/Webifile" | grep -v '^$' | awk '{print $1}' | grep -v '^$')

# Install each package
for package in $packages; do
    echo "Installing $package..."
    webi "$package"
done

echo "Webi package installation complete!"