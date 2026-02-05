#!/usr/bin/env bash

# Custom shell functions for enhanced productivity

# ═══════════════════════════════════════════════════════════════════════════
# fzf Preview Helper
# ═══════════════════════════════════════════════════════════════════════════
# This function is used by completions.zsh and external.zsh for fzf previews

_fzf_complete_realpath () {
  # Used for tab completion in completions.zsh and external.zsh.
  # Can be customized to behave differently for different objects.
  local realpath="${1:--}"  # read the first arg or stdin if arg is missing

  if [ "$realpath" = '-' ]; then
    # It is a stdin, always a text content:
    local stdin="$(< /dev/stdin)"
    echo "$stdin" | bat \
      --language=sh \
      --plain \
      --color=always \
      --wrap=character \
      --terminal-width="$FZF_PREVIEW_COLUMNS" \
      --line-range :100
    return
  fi

  if [ -d "$realpath" ]; then
    tree -a -I '.DS_Store|.localized' -C "$realpath" | head -100
  elif [ -f "$realpath" ]; then
    mime="$(file -Lbs --mime-type "$realpath")"
    category="${mime%%/*}"
    if [ "$category" = 'image' ]; then
      # I guessed `60` to be fine for my exact terminal size
      local default_width=$(( "$FZF_PREVIEW_COLUMNS" < 60 ? 60 : "$FZF_PREVIEW_COLUMNS" ))
      catimg -r2 -w "$default_width" "$realpath"
    elif [[ "$mime" =~ 'binary' ]]; then
      hexyl --length 5KiB \
        --border none \
        --terminal-width "$FZF_PREVIEW_COLUMNS" \
        "$realpath"
    else
      bat --number \
        --color=always \
        --line-range :100 \
        --theme="$SOBOLE_SYNTAX_THEME" \
        "$realpath"
    fi
  else
    # This is not a directory and not a file, just print the string.
    echo "$realpath" | fold -w "$FZF_PREVIEW_COLUMNS"
  fi
}

# ═══════════════════════════════════════════════════════════════════════════
# Utility Functions
# ═══════════════════════════════════════════════════════════════════════════

# List all custom functions with descriptions
list_functions() {
	grep -E '^# |^[a-zA-Z0-9_]*\(\)' ~/.dotfiles/dotconfig/zsh/functions.zsh |
	sed 'N;s/# \(.*\)\n\(.*\)/\2 - \1/'
}

# Add 's' suffix for pluralization when count is not 1
optional_s() {
	[ "$1" -ne 1 ] && echo "s"
}

# ═══════════════════════════════════════════════════════════════════════════
# File System Functions
# ═══════════════════════════════════════════════════════════════════════════

# Create directory and change into it
mkcdir() {
	mkdir -p "$1" && cd "$1"
}

# Create file with any necessary parent directories
mktouch() {
	mkdir -p "$(dirname "$1")" && touch "$1"
}

# Remove macOS system files and hidden directories from current directory
dot_clean() {
	find . -name ".DS_Store" -delete 2>/dev/null
	find . -name ".Spotlight-V100" -delete 2>/dev/null
	find . -name ".Trashes" -delete 2>/dev/null
	find . -name ".Trash-*" -delete 2>/dev/null
	find . -name "Thumbs.db" -delete 2>/dev/null
	find . -name "Desktop.ini" -delete 2>/dev/null

	local count
	count=$(find . \( -name ".DS_Store" -o -name ".Spotlight-V100" -o -name ".Trashes" -o -name ".Trash-*" -o -name "Thumbs.db" -o -name "Desktop.ini" \) | wc -l | tr -d ' ')
	echo "Processed $count item$(optional_s "$count")"
}

# ═══════════════════════════════════════════════════════════════════════════
# Git Functions
# ═══════════════════════════════════════════════════════════════════════════

# Get the current git branch name
git_current_branch() {
	git branch --show-current
}

# Get the default branch name from remote origin
git_default_branch() {
	git remote show origin | sed -n '/HEAD branch/s/.*: //p'
}

# Remove git branches that have been merged into the default branch
git_prune_branches() {
	local default_branch
	default_branch=$(git_default_branch)

	local merged_branches
	merged_branches=$(git branch --merged "$default_branch" | grep -v "\* $default_branch" | grep -v "^  $default_branch$")

	if [ -z "$merged_branches" ]; then
		echo "No merged branches to prune"
		return
	fi

	echo "$merged_branches" > /tmp/branches_to_delete
	"${EDITOR:-vim}" /tmp/branches_to_delete

	while IFS= read -r branch; do
		if [ -n "$branch" ]; then
			git branch -d "$(echo "$branch" | xargs)"
		fi
	done < /tmp/branches_to_delete

	rm /tmp/branches_to_delete
}

# Get the year a file was first added to git repository
file_addition_year() {
	git log --follow --format=%ad --date=format:%Y "$1" | tail -1
}

# List git stashes with detailed information about files changed
git_stash_list() {
	local stash_count
	stash_count=$(git stash list | wc -l | xargs)

	if [ "$stash_count" -eq 0 ]; then
		echo "No stashes found"
		return
	fi

	echo "Found $stash_count stash$(optional_s "$stash_count"):"
	echo ""

	git stash list | while IFS= read -r stash_line; do
		local stash_id
		stash_id=$(echo "$stash_line" | cut -d: -f1)

		echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
		echo "$stash_line"
		echo ""
		echo "Files changed:"
		git stash show --name-status "$stash_id" | sed 's/^/  /'
		echo ""
	done
}

# ═══════════════════════════════════════════════════════════════════════════
# System Functions
# ═══════════════════════════════════════════════════════════════════════════

# Check if current shell session is over SSH
is_ssh() {
	[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}

# ═══════════════════════════════════════════════════════════════════════════
# Personal Management Functions
# ═══════════════════════════════════════════════════════════════════════════

# Get the Monday date of the current ISO week (for weekly file naming)
_week_monday() {
	# Get current day of week (1=Monday, 7=Sunday)
	local dow=$(date +%u)
	# Calculate days since Monday
	local days_since_monday=$((dow - 1))
	# Get Monday's date
	date -v-${days_since_monday}d +%Y-%m-%d
}

# Get the current week file path
_week_file() {
	local year=$(date +%Y)
	local monday=$(_week_monday)
	echo "$HOME/notes/pm-system/planning/weeks/week-$monday.md"
}


