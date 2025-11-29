#!/usr/bin/env bash

# `.completions` handles all custom auto-completions.

# ═══════════════════════════════════════════════════════════════════════════
# General Completion Settings
# ═══════════════════════════════════════════════════════════════════════════

# Enable hidden files on completion
setopt globdots

# Uncomment to set `CTRL-k` to show debug info:
# Usage: `your command <CTRL-k>`
# bindkey '^k' _complete_help

# ═══════════════════════════════════════════════════════════════════════════
# fzf-tab Configuration
# ═══════════════════════════════════════════════════════════════════════════
# https://github.com/Aloxaf/fzf-tab

# Enable hidden files on completion
zstyle ':completion:*' special-dirs true

# Hide parents and system files
zstyle ':completion:*' ignored-patterns '.|..|.DS_Store|**/.|**/..|**/.DS_Store|**/.git'

# Hide `..` and `.` from file menu
zstyle ':completion:*' ignore-parents 'parent pwd directory'

# Force zsh not to show completion menu,
# which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# Switch groups using `[` and `]`
zstyle ':fzf-tab:*' switch-group '[' ']'

# Use the same layout as others and respect my default
zstyle -a ':fzf-tab:*' fzf-flags __fzf_tab_flags
__fzf_tab_flags=( "${__fzf_tab_flags[@]}" '--layout=reverse-list' )
zstyle ':fzf-tab:*' fzf-flags $__fzf_tab_flags
unset __fzf_tab_flags

# ═══════════════════════════════════════════════════════════════════════════
# Tool-Specific Completions
# ═══════════════════════════════════════════════════════════════════════════
# Big sources of inspiration:
# - https://github.com/Freed-Wu/fzf-tab-source
# - https://github.com/DanielFGray/fzf-scripts

# Complete `fzf`
compdef _gnu_generic fzf

# Complete `ls` / `cat` / etc
zstyle ':fzf-tab:complete:(\\|*/|)(ls|gls|bat|cat|cd|rm|cp|mv|ln|nano|code|open|tree|source):*' \
  fzf-preview \
  '_fzf_complete_realpath "$realpath"'

# Complete `make`
zstyle ':fzf-tab:complete:(\\|*/|)make:*' fzf-preview \
  'case "$group" in
  "[make target]")
    make -n "$word" | _fzf_complete_realpath
    ;;
  "[make variable]")
    make -pq | ag "^$word =" | _fzf_complete_realpath
    ;;
  "[file]")
    _fzf_complete_realpath "$realpath"
    ;;
  esac'

# Complete `killall`
zstyle ':completion:*:*:killall:*:*' command 'ps -u "$USERNAME" -o comm'
zstyle ':fzf-tab:complete:(\\|*/|)killall:*' fzf-preview \
  'ps aux | ag "$word" | _fzf_complete_realpath'
