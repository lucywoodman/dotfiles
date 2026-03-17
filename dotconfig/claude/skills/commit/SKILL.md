---
name: commit
description: Stage and commit changes using conventional commit format
allowed-tools: Bash(git *)
argument-hint: [--all | --staged | path...]
---

Create conventional commits from the current changes.

## Workflow

1. **Assess what to commit:**
   - If `$ARGUMENTS` contains `--staged`: use only already-staged changes
   - If `$ARGUMENTS` contains `--all`: consider all modified and untracked files
   - If `$ARGUMENTS` contains file paths: focus on those specific files
   - If `$ARGUMENTS` is empty: consider all modified and untracked files
   - Run `git status` and `git diff` (staged and/or unstaged as appropriate)

2. **Group changes by logical concern:**
   - Changes that form a single coherent unit get one commit
   - Unrelated changes should be split into separate commits
   - If all changes are related, a single commit is fine

3. **For each commit group, determine:**
   - **type**: feat, fix, refactor, docs, chore, test, style, perf, ci, build
   - **scope**: the area affected (e.g., zsh, git, claude, brew) — omit if too broad
   - **description**: imperative mood, lowercase, no period, explains the "why"

4. **Present the plan for confirmation:**
   ```
   Commit 1: type(scope): description
     Stage: file1.ext, file2.ext

   Commit 2: type(scope): description
     Stage: file3.ext
   ```
   Wait for explicit approval before proceeding.

5. **Execute after approval:**
   - Stage the specific files for each commit (never use `git add -A` or `git add .`)
   - Commit with the agreed message
   - Run `git status` after the final commit to confirm clean state

## Commit Message Rules

- Format: `type(scope): description`
- Description in imperative mood ("add", "fix", "update" — not "added", "fixes")
- Lowercase description, no trailing period
- Add a body (blank line after subject) only when the "why" isn't obvious from the subject
- Never add `Co-authored-by` trailers
- Never skip pre-commit hooks

## Examples

Good:
- `feat(zsh): add fzf preview for git worktrees`
- `fix(git): skip worktree branches in gone alias`
- `chore(brew): remove unused terraform-ls`
- `refactor(claude): extract agent definitions from research skill`

Bad:
- `Updated files` (no type, vague)
- `feat: Add new feature for ZSH.` (capitalized, has period, vague)
- `fix(git): fixes the bug` (not imperative, vague)
