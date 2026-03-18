---
name: validate
description: Check implementation progress against a plan file's success criteria
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(ls *), Bash(test *), Bash(cat *), Agent
argument-hint: [plan-file-path]
---

Validate the current implementation against a plan file's success criteria.

## Workflow

1. **Locate the plan file:**
   - If `$ARGUMENTS` is a path: read that file directly
   - If `$ARGUMENTS` is a search term: look for a matching file in `~/thoughts/shared/plans/`
   - If `$ARGUMENTS` is empty: use the most recently modified file in `~/thoughts/shared/plans/`
   - If no plan file is found, say so and stop

2. **Read the plan file** and extract:
   - The goal and approach (for context)
   - The files-to-change list
   - The success criteria checklist

3. **Check each success criterion:**
   - Use the appropriate verification method:
     - File existence → `ls` or Glob
     - Code changes → `git diff`, Grep, or Read
     - Test results → run the test command if specified
     - Command output → run the command and check
   - Use sub-agents (codebase-locator, codebase-analyzer) for complex checks that require searching across the codebase

4. **Report results:**

   ```
   Plan: [plan title]
   File: [plan file path]

   ## Success Criteria

   PASS  Criterion 1
   PASS  Criterion 2
   FAIL  Criterion 3 — [brief reason]
   SKIP  Criterion 4 — [why it couldn't be checked]

   ## Summary

   X/Y criteria passed. [Remaining work if incomplete.]
   ```

5. **If incomplete**, list the specific remaining work needed to satisfy failing criteria.

## Important

- Read the plan file thoroughly before checking anything
- Check criteria in order — some may depend on earlier ones
- Be precise about what passed vs what failed — don't guess
- If a criterion is ambiguous, check what you can and note the ambiguity
