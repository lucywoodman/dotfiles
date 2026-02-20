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
# Navigation Functions
# ═══════════════════════════════════════════════════════════════════════════

# Navigate to workspace, optionally into a GitHub org/repo (e.g. workspace org/repo)
workspace() {
	cd "$HOME/workspace/${1:+github.com/$1}"
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
# Worktree Functions
# ═══════════════════════════════════════════════════════════════════════════

# Get the main worktree root (not the current worktree)
_wt_root() {
	git worktree list --porcelain | head -1 | sed 's/worktree //'
}

# Create a worktree and open it in a tmux window
wt() {
	if [ -z "$1" ]; then
		echo "Usage: wt <branch>"
		return 1
	fi

	local branch="$1"
	local root=$(_wt_root)
	local wt_dir="${root}/../$(basename "${root}")-worktrees/${branch}"

	# Create worktree if it doesn't already exist
	if [ ! -d "$wt_dir" ]; then
		if git show-ref --verify --quiet "refs/heads/${branch}"; then
			git worktree add "$wt_dir" "$branch" || return 1
		elif git show-ref --verify --quiet "refs/remotes/origin/${branch}"; then
			git worktree add "$wt_dir" --track -b "$branch" "origin/${branch}" || return 1
		else
			git worktree add "$wt_dir" -b "$branch" || return 1
		fi
	fi

	# Open in tmux window or just cd
	if [ -n "$TMUX" ]; then
		tmux new-window -n "$branch" -c "$wt_dir"
	else
		cd "$wt_dir"
	fi
}

# Switch between worktrees via fzf
wts() {
	local selected
	selected=$(git worktree list | fzf \
		--prompt="worktree> " \
		--preview='git log --oneline -10 --color=always {2}' \
		--preview-window=right:50%) || return

	local wt_path branch
	wt_path=$(echo "$selected" | awk '{print $1}')
	branch=$(echo "$selected" | awk '{print $3}' | tr -d '[]')

	if [ -n "$TMUX" ]; then
		# Switch to existing window or create one
		if tmux select-window -t ":${branch}" 2>/dev/null; then
			return
		fi
		tmux new-window -n "$branch" -c "$wt_path"
	else
		cd "$wt_path"
	fi
}

# Remove a worktree and optionally delete the branch
wtd() {
	local branch="${1:-$(git branch --show-current)}"

	if [ -z "$branch" ]; then
		echo "Usage: wtd <branch> (or run from within a worktree branch)"
		return 1
	fi

	local root=$(_wt_root)
	local wt_dir="${root}/../$(basename "${root}")-worktrees/${branch}"

	if [ ! -d "$wt_dir" ]; then
		echo "Worktree not found: $wt_dir"
		return 1
	fi

	# Move out if we're inside the worktree
	case "$PWD" in
		"$wt_dir"*) cd "$root" ;;
	esac

	# Remove the worktree (refuses if dirty)
	git worktree remove "$wt_dir" || return 1

	# Prompt to delete the branch
	printf "Delete branch '%s'? [y/N] " "$branch"
	read -r reply
	if [ "$reply" = "y" ] || [ "$reply" = "Y" ]; then
		git branch -d "$branch"
	fi

	# Close the tmux window if it exists
	if [ -n "$TMUX" ]; then
		tmux kill-window -t ":${branch}" 2>/dev/null
	fi
}

# Mission Control — monitor all Claude sessions across tmux
mc() {
	uv run --quiet --script ~/.dotfiles/dotconfig/bin/mc "$@"
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


