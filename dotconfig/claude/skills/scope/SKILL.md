---
name: scope
description: Fetches a Jira or GitHub ticket, then enters plan mode for implementation planning.
allowed-tools: Bash(jira *), Bash(gh *), EnterPlanMode
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
