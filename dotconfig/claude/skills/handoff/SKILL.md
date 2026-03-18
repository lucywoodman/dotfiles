---
name: handoff
description: Capture session state for the next session to pick up where we left off
allowed-tools: Bash(git *), Bash(ls *), Bash(date *), Bash(cat *), Read, Glob, Write
---

Capture the current session state so the next session can continue seamlessly.

## Workflow

1. **Gather git state:**
   - `git status` — working tree state, staged files
   - `git branch --show-current` — current branch
   - `git log --oneline -5` — recent commits
   - `git stash list` — any stashed work
   - `git diff --stat` — uncommitted change summary

2. **Review the conversation so far:**
   - What was accomplished this session
   - What remains to be done
   - Key decisions made and their rationale
   - Any blockers or open questions
   - Commands or approaches that failed (so they're not retried)

3. **Check for an active plan file:**
   - Look for the most recent file in `~/thoughts/shared/plans/`
   - If one exists and relates to the current work, note its path

4. **Write the handoff file:**
   - Path: `<project-root>/.claude/handoff.md` (always overwritten — this is latest state, not history)
   - Use the format below

## Handoff File Format

```markdown
---
date: YYYY-MM-DD HH:MM
branch: <current-branch>
---

# Session Handoff

## Current State
[Git state: branch, clean/dirty, recent commits]

## Completed
- [What was accomplished this session, with specific file paths]

## Remaining
- [ ] [What still needs to be done]
- [ ] [Next immediate step]

## Decisions
- [Key decisions made and why — so they're not re-debated]

## Failed Approaches
- [Anything that was tried and didn't work, with brief reason]

## Verification
[Commands to run to confirm the current state is as expected]
```bash
# Example verification commands
git status
git log --oneline -3
```

## Plan Reference
[Path to active plan file, if any: ~/thoughts/shared/plans/YYYY-MM-DD-description.md]
```

## Important

- Always overwrite the handoff file — it represents the latest state, not a history
- Be specific about file paths and commit hashes, not vague summaries
- The "Remaining" section should be actionable — the next session should be able to start working immediately
- Include verification commands that confirm state hasn't drifted between sessions
- Keep it concise — this is a handoff note, not a research document
