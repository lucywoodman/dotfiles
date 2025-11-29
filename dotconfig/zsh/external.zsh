#!/usr/bin/env bash

# `.external` handles all complex external tools and integrations.

# ═══════════════════════════════════════════════════════════════════════════
# fzf - Fuzzy Finder
# ═══════════════════════════════════════════════════════════════════════════
# https://github.com/junegunn/fzf

# Enable fzf shell integration
# Supports both Homebrew and webi installations
if command -v fzf >/dev/null 2>&1; then
  # Try Homebrew installation first (preferred)
  if [[ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ]]; then
    source "/opt/homebrew/opt/fzf/shell/completion.zsh"
    source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
  else
    # Fall back to webi or other installation
    eval "$(fzf --zsh)"
  fi
fi

# fzf environment configuration
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_OPTS="--preview '_fzf_complete_realpath {}'"
export FZF_ALT_C_OPTS="--preview '_fzf_complete_realpath {}'"

# fzf display options
# Use generator to customize: https://vitormv.github.io/fzf-themes/
# To add wrap lines add: --preview-window=wrap
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
--layout=reverse-list
--bind 'ctrl-a:toggle'
--bind 'ctrl-h:change-preview-window(hidden|)'
--cycle
-i
"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path () {
  fd --hidden --no-ignore-vcs --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir () {
  fd --type=d --hidden --no-ignore-vcs --exclude .git . "$1"
}

# See `completions.zsh` for the full list of fzf tab completions.

# ═══════════════════════════════════════════════════════════════════════════
# zoxide - Smarter cd Command
# ═══════════════════════════════════════════════════════════════════════════
# https://github.com/ajeetdsouza/zoxide

# `zoxide` has an option to use `fzf` to provide completions natively,
# but it works only for `z NAME<SPACE><TAB>`,
# it does not work for `z NAME<TAB>`.
# So, we define a custom completion here.
eval "$(zoxide init zsh --no-cmd)"

z () {
  # I need this function to setup custom code completion for `zoxide`.
  \__zoxide_z "$@"
}

# Custom zoxide completion (defined after z function)
_z () {
  # I have a custom completion, because I like `z NAME<TAB>`
  # and not `z NAME<SPACE><TAB>`
  local args
  args="$(zoxide query -a -l)"
  _arguments "1:paths:($args)"
}

compdef _z z
zstyle ':fzf-tab:complete:(\\|*/|)z:*' fzf-preview \
  '_fzf_complete_realpath "$word"'
