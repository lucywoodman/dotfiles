---
name: today
description: Show today's meetings, tasks from the weekly log, and vault tasks due or high-priority, with optional prioritisation using recent notes for context
allowed-tools: Bash(date *), Bash(ls *), Read, Glob
argument-hint: [prioritise]
---

Show today's meetings and open tasks from the weekly bullet journal log.

## Data sources

All paths are absolute — do not assume a working directory.

1. **Weekly log:** `~/thoughts/references/YYYY-Www-weekly.md` (ISO week format). Determine the current week label by running `date +%G-W%V`.
2. **Cached calendar:** `$CLAUDE_DATA_SOURCES/today.md`
3. **Cached Jira:** `$CLAUDE_DATA_SOURCES/jira.md`
4. **Obsidian notes vault:** `~/thoughts/` (flat folder, files named `YYYY-MM-DD-HHMM.md`)
5. **Vault tasks:** `~/thoughts/tasks/active/*.md` — task files with frontmatter fields `priority` (high/medium/low), `due` (YYYY-MM-DD or empty), and a `# Task:` heading containing the title

## Workflow

### 1. Gather data

Read these files (skip any that don't exist):

- The current week's log file
- `$CLAUDE_DATA_SOURCES/today.md` for today's calendar detail
- `$CLAUDE_DATA_SOURCES/jira.md` for current Jira ticket statuses

### 2. Present today's view

#### Meetings

From the weekly log's `### Meetings` section, show only meetings for **today's day name** (e.g. "Mon", "Tue"). Include their checkbox state so the user can see what's done.

If the cached `today.md` has richer detail (attendees, notes) for an upcoming meeting, mention it briefly.

#### Tasks

From the weekly log's `### Tasks` section, show all tasks. Mark which are already checked off. Cross-reference with `jira.md` to show current Jira status (e.g. "In Review", "Approved") next to each ticket.

#### Vault tasks

Use Glob to find all files in `~/thoughts/tasks/active/`. Read each file's frontmatter to extract `priority` and `due`. Show:

1. **Due today:** Any tasks where `due` matches today's date (YYYY-MM-DD). Show all of them.
2. **Top priority:** The first task when all active tasks are sorted by priority (high > medium > low). If the top priority task is already shown as due today, show the next one instead so there's no duplication. If there are multiple tasks sharing the highest priority level, pick the one with the earliest `created` date.

Display the task title (from the `# Task:` heading, without the `Task: ` prefix) along with its priority and due date (if set).

#### Today's log

If today's day heading (e.g. `### Tuesday`) in the weekly log already has session or activity data, show a brief summary of what's been worked on so far today.

### 3. Prioritise (only when `$ARGUMENTS` contains "prioritise")

When asked to prioritise, gather additional context first:

- **Recent notes:** Use Glob to find notes from the last 2 days in `~/thoughts/` matching today's and yesterday's date patterns (e.g. `2026-04-14-*.md`, `2026-04-13-*.md`). If today is Monday, also check Friday. Read them for context about what the user has been thinking about and working on.
- **Session history:** Look at the current weekly log's day-by-day `### Log` entries to understand what work has already been done this week.

Then suggest a prioritised task order considering:

- **Jira status:** "Approved" tickets likely need work started; "In Review" tickets may need follow-up
- **Context from notes:** What the user was focused on or mentioned as important
- **Meeting prep:** Tasks related to upcoming meetings today
- **Momentum:** Continue work already in progress (visible from sessions)

Present the prioritised list with brief reasoning for the ordering.

## Output format

Keep it scannable. Use this structure:

```
## Today — {Day}, {Date}

### Meetings
{meeting list with times and checkbox state}

### Tasks
{task list with checkbox state and Jira status}

### Vault tasks
📌 Due today: {tasks due today, or "None"}
⭐ Top priority: {highest priority task title} ({priority})

### So far today
{brief session summary if any, or "Nothing logged yet."}
```

When prioritising, add:

```
### Suggested priority
1. {task} — {reason}
2. {task} — {reason}
...
```

## Rules

- Read-only: never modify the weekly log, notes vault, or data source files
- Don't show meetings for other days — focus on today
- Don't overwhelm: keep output concise and actionable
- If a data source is missing, mention it briefly and continue with what's available
