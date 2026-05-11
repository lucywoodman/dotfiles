---
name: retro
description: Draft a weekly retrospective by reading the week's log, notes, and Jira data, then present (or write) a structured review
allowed-tools: Bash(date *), Bash(ls *), Read, Glob, Edit
argument-hint: [write] [YYYY-Www]
---

Draft a weekly review for a completed week.

## Arguments

- **`$ARGUMENTS`** may contain:
  - A week label like `2026-W16` to target a specific week. If omitted, default to the **previous** ISO week (run `date -v-7d +%G-W%V` to calculate).
  - The word `write` — if present, write the review into the weekly log file. Otherwise, present it as output only.

## Data sources

All paths are absolute — do not assume a working directory.

1. **Weekly log:** `~/thoughts/references/YYYY-Www-weekly.md`
2. **Obsidian notes vault:** `~/thoughts/` — notes named `YYYY-MM-DD-*.md` at root, meeting notes in `references/YYYY-MM-DD-*.md`, daily notes in `daily/YYYY-MM-DD.md`
3. **Cached Jira:** `$CLAUDE_DATA_SOURCES/jira.md`

## Workflow

### 1. Determine target week

Parse `$ARGUMENTS` for a week label (e.g. `2026-W16`). If none given, calculate the previous week with `date -v-7d +%G-W%V`.

Read the target week's log file. If it doesn't exist, tell the user and stop.

### 2. Calculate the date range

From the ISO week label, determine the Monday–Friday dates for note scanning. Use `date` commands to derive the dates:

```bash
# Example: get Monday of ISO week
date -v+1d -j -f "%G-W%V-%u" "2026-W16-1" +%Y-%m-%d
```

### 3. Gather context

Read these sources (skip any that don't exist):

- **The weekly log** (already read in step 1) — extract the Plan (meetings, tasks with checkbox states) and the Log (sessions, activity summaries)
- **Notes from the week** — Glob for `YYYY-MM-DD-*.md` at `~/thoughts/` for each day Mon–Fri of the target week. Also glob `~/thoughts/references/YYYY-MM-DD-*.md` and `~/thoughts/daily/YYYY-MM-DD.md`. Read each match for context.
- **Cached Jira** — read `$CLAUDE_DATA_SOURCES/jira.md` to cross-reference ticket statuses (In Review, Approved, Done, etc.)

### 4. Synthesise the review

Analyse all gathered data and draft a review with these sections:

#### Wins
What was accomplished. Lead with the most impactful work. Reference ticket numbers. Keep each bullet to 1–2 sentences — enough context to be useful months later, not a retelling of the week.

#### Carried forward
Tasks from the Plan that are still open (`- [ ]`). Include current Jira status if available. Use task checkbox syntax so they're trackable.

#### Context for next week
Decisions, deadlines, or information that the user needs to be aware of going into the next week. Pull from meeting notes, 1:1s, and session context. Include people's availability changes, upcoming deadlines, and priority guidance from managers.

### 5. Present or write

- **If `write` is NOT in `$ARGUMENTS`:** Output the review as markdown. Tell the user they can re-run with `write` to save it.
- **If `write` IS in `$ARGUMENTS`:** Use the Edit tool to replace the `## Review` section content in the weekly log file. Preserve the `## Review` heading. Replace everything between it and the end of file (or next `##` heading).

## Output format

```markdown
**Wins**
- {accomplishment} — {ticket} {brief context}
- ...

**Carried forward**
- [ ] {ticket} {title} — {current status}
- ...

**Context for {next week label}**
- {deadline, decision, or awareness item}
- ...
```

## Rules

- Default is read-only — only modify the weekly log when `write` is explicitly passed
- Don't invent information — only include what's evidenced in the log, notes, or Jira data
- Don't include health data or deeply personal content in the review — keep it professional with at most a brief personal note if the week's journal entries suggest one
- Keep it concise — the review should be scannable, not a narrative
- Use wikilinks for internal references where appropriate
- Reference ticket numbers in Jira link format where possible
