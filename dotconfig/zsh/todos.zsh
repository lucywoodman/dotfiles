#!/usr/bin/env zsh

# ═══════════════════════════════════════════════════════════════════════════
# Todo Management Functions
# ═══════════════════════════════════════════════════════════════════════════
# Todos are stored as markdown files:
#   ~/notes/tasks/active/    - current todos
#   ~/notes/tasks/completed/ - done todos (with completed: date in frontmatter)

# List or add todos
todo() {
	mkdir -p ~/notes/tasks/active ~/notes/tasks/completed

	if [ -z "$1" ]; then
		# No args - list todos
		echo "📋 Active Todos"
		echo ""
		local i=1
		for taskfile in ~/notes/tasks/active/*.md(N); do
			if [ -f "$taskfile" ]; then
				local title=$(grep "^# Task:" "$taskfile" 2>/dev/null | sed 's/^# Task: //')
				local priority=$(grep "^priority:" "$taskfile" 2>/dev/null | sed 's/^priority: *//' | tr -d ' ')
				local due=$(grep "^due:" "$taskfile" 2>/dev/null | sed 's/^due://' | tr -d ' ')
				local created=$(grep "^created:" "$taskfile" 2>/dev/null | sed 's/^created: *//' | tr -d ' ')

				local badge=""
				[ "$priority" = "high" ] && badge="🔴"
				[ "$priority" = "medium" ] && badge="🟡"
				[ "$priority" = "low" ] && badge="🟢"

				local due_str=""
				[ -n "$due" ] && due_str=" (due: $due)"

				echo "  $i. $badge $title$due_str"
				i=$((i + 1))
			fi
		done
		if [ $i -eq 1 ]; then
			echo "  No active todos."
			echo ""
			echo "  Add one with: todo \"description\""
			echo "  Or with priority: todo \"description\" high"
		fi
		return
	fi

	# Check for subcommands
	case "$1" in
		-h|--help|help)
			echo "Usage:"
			echo "  todo                     List active todos"
			echo "  todo \"description\"       Add todo (medium priority)"
			echo "  todo \"description\" high  Add todo with priority (high/medium/low)"
			echo "  todo done <number>       Complete todo"
			echo "  todo drop <number>       Remove todo"
			echo "  todo edit <number>       Edit todo in \$EDITOR"
			echo "  todo today               Show todos completed today"
			return
			;;
		done)
			_todo_done "$2"
			return
			;;
		drop)
			_todo_drop "$2"
			return
			;;
		edit)
			_todo_edit "$2"
			return
			;;
		today)
			_todo_today
			return
			;;
	esac

	# Add new todo
	local description="$1"
	local priority="${2:-medium}"

	local date_prefix=$(date +%Y-%m-%d)
	local slug=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-40)
	local file=~/notes/tasks/active/${date_prefix}-${slug}.md

	# Handle collision by appending a number
	if [ -f "$file" ]; then
		local n=2
		while [ -f "${file%.md}-${n}.md" ]; do
			n=$((n + 1))
		done
		file="${file%.md}-${n}.md"
	fi

	cat > "$file" << EOF
---
created: $(date +%Y-%m-%d)
priority: $priority
due:
context:
---

# Task: $description

## Notes

EOF

	local badge=""
	[ "$priority" = "high" ] && badge="🔴"
	[ "$priority" = "medium" ] && badge="🟡"
	[ "$priority" = "low" ] && badge="🟢"

	echo "✅ Task added: $badge $description"
	local count=$(ls -1 ~/notes/tasks/active/*.md 2>/dev/null | wc -l | tr -d ' ')
	echo "   Active tasks: $count"
}

# Mark todo as done by number (internal)
_todo_done() {
	if [ -z "$1" ]; then
		echo "Usage: todo done <number>"
		todo
		return 1
	fi

	local i=1
	for taskfile in ~/notes/tasks/active/*.md(N); do
		if [ -f "$taskfile" ] && [ $i -eq "$1" ]; then
			local title=$(grep "^# Task:" "$taskfile" 2>/dev/null | sed 's/^# Task: //')
			# Add completed date after the opening ---
			sed -i '' "/^---$/a\\
completed: $(date +%Y-%m-%d)
" "$taskfile"
			mv "$taskfile" ~/notes/tasks/completed/
			echo "✅ Completed: $title"
			local remaining=$(ls -1 ~/notes/tasks/active/*.md 2>/dev/null | wc -l | tr -d ' ')
			echo "   Remaining: $remaining tasks"
			return
		fi
		i=$((i + 1))
	done
	echo "Todo #$1 not found"
	todo
}

# Drop todo without completing (internal)
_todo_drop() {
	if [ -z "$1" ]; then
		echo "Usage: todo drop <number>"
		todo
		return 1
	fi

	local i=1
	for taskfile in ~/notes/tasks/active/*.md(N); do
		if [ -f "$taskfile" ] && [ $i -eq "$1" ]; then
			local title=$(grep "^# Task:" "$taskfile" 2>/dev/null | sed 's/^# Task: //')
			rm "$taskfile"
			echo "🗑️  Dropped: $title"
			return
		fi
		i=$((i + 1))
	done
	echo "Todo #$1 not found"
}

# Edit todo in editor (internal)
_todo_edit() {
	if [ -z "$1" ]; then
		echo "Usage: todo edit <number>"
		todo
		return 1
	fi

	local i=1
	for taskfile in ~/notes/tasks/active/*.md(N); do
		if [ -f "$taskfile" ] && [ $i -eq "$1" ]; then
			${EDITOR:-nvim} "$taskfile"
			return
		fi
		i=$((i + 1))
	done
	echo "Todo #$1 not found"
}

# Show todos completed today (internal)
_todo_today() {
	local today=$(date +%Y-%m-%d)
	echo "✅ Todos completed today ($today)"
	echo ""

	local found=0
	for taskfile in ~/notes/tasks/completed/*.md(N); do
		if [ -f "$taskfile" ]; then
			local completed=$(grep "^completed:" "$taskfile" 2>/dev/null | sed 's/^completed: *//' | tr -d ' ')
			if [ "$completed" = "$today" ]; then
				local title=$(grep "^# Task:" "$taskfile" 2>/dev/null | sed 's/^# Task: //')
				echo "  ✓ $title"
				found=$((found + 1))
			fi
		fi
	done

	if [ $found -eq 0 ]; then
		echo "  No todos completed today yet."
	else
		echo ""
		echo "  Total: $found"
	fi
}
