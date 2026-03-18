---
name: scope
description: Fetches a Jira or GitHub ticket, then enters plan mode for implementation planning.
allowed-tools: Bash(jira *), Bash(gh *), Bash(mkdir *), Bash(date *), EnterPlanMode, Write
argument-hint: [PROJECT-123 | issue-number]
---

Fetch ticket $ARGUMENTS and enter plan mode.

## Workflow

1. **Detect ticket type:**
   - Jira key pattern (e.g. SRET-123, BC-456, INC-78) → Jira
   - Numeric only → GitHub issue

2. **Fetch ticket details:**
   - Jira: `jira issue view $ARGUMENTS`
   - GitHub: `gh issue view $ARGUMENTS --json title,body,state,url,labels`

3. **Enter plan mode** to explore the codebase and plan the implementation.

4. **After planning is complete**, write the plan to a file for persistence:
   - Path: `~/thoughts/shared/plans/YYYY-MM-DD-TICKET-description.md`
     - TICKET is the ticket key (e.g. SRET-123) or issue number — omit if none
     - description is a brief kebab-case summary
   - Create `~/thoughts/shared/plans/` if it doesn't exist

## Plan File Format

```markdown
---
date: YYYY-MM-DD
ticket: TICKET-KEY or null
status: planned
---

# Plan: [Brief title]

## Goal
[What we're trying to achieve, derived from the ticket]

## Approach
[High-level strategy and key decisions]

## Files to Change
- `path/to/file.ext` — what changes and why

## PR Sequence
[If multiple PRs, list them with scope and dependencies]

## Success Criteria
- [ ] Criterion 1 (testable/verifiable statement)
- [ ] Criterion 2
```

## Important

- The plan file is the source of truth for what was agreed during planning
- Keep success criteria concrete and verifiable (file exists, test passes, command outputs X)
- The `/validate` skill reads these plan files to check implementation progress
