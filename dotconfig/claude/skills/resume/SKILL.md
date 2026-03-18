---
name: resume
description: Pick up where the last session left off using the handoff file
allowed-tools: Read, Glob, Bash(git *), Bash(ls *), Bash(cat *), EnterPlanMode
---

Resume work from where the last session left off.

## Workflow

1. **Read the handoff file:**
   - Look for `.claude/handoff.md` in the current project root
   - If not found, say so and offer to start fresh
   - Note the date to gauge how stale the handoff is

2. **Read the referenced plan file (if linked):**
   - If the handoff references a plan in `~/thoughts/shared/plans/`, read it
   - Extract the success criteria and remaining work

3. **Verify current state matches the handoff:**
   - Run the verification commands from the handoff file
   - Run `git status`, `git branch --show-current`, `git log --oneline -3`
   - Compare against what the handoff says the state should be
   - Flag any discrepancies (e.g., branch changed, new commits appeared, uncommitted work)

4. **Present a summary:**

   ```
   Resuming from: [date]
   Branch: [branch name]
   State: [clean/dirty, matches handoff or not]

   Last session completed:
   - [completed items]

   Remaining work:
   - [ ] [remaining items from handoff]

   Plan: [plan file path, if any]

   [Any state discrepancies or warnings]
   ```

5. **Determine next action:**
   - If there's remaining work with a plan file: enter plan mode so the plan can be reviewed before continuing
   - If there's remaining work without a plan: present the remaining items and ask what to tackle first
   - If everything was completed: report that and ask what's next

## Important

- Always verify state before assuming the handoff is accurate — things may have changed between sessions
- If the handoff is more than a few days old, note that context may be stale
- Don't silently start working — present the summary and get confirmation first
- If state has drifted significantly from the handoff, flag it clearly rather than guessing
