 Analyse the current unstaged changes and create logical, focused commits: $ARGUMENTS

## Step 1: ASSESS CURRENT STATE
```bash
git branch --show-current
git status --porcelain
git diff --name-only
```
If not already on a feature branch:
1. Check for uncommitted changes: If there are staged changes, ask Lucy what to do
2. Create a new branch
3. Switch to new branch

## Step 2: ANALYSE CHANGES BY TYPE
Group unstaged changes into logical commits by examining:
- Related functionality (files that work together)
- Bug fixes vs new features vs refactoring
- Documentation changes
- Test changes that belong with their implementation
- Configuration or build changes
For each file, understand:
`git diff path/to/file`

## Step 3: CREATE LOGICAL COMMITS
Create separate commits for:
1. Bug fixes - Each bug fix should be its own commit
2. Features - Related feature files grouped together
3. Refactoring - Pure refactoring separate from functional changes
4. Tests - Tests that belong with their implementation (grouped with feature/fix)
5. Documentation - README, comments, docs
6. Configuration - Build files, dependencies, settings
7. Formatting - Pure formatting/linting changes

## Step 4: COMMIT STRATEGY
For each logical group:
```bash
git add [specific files for this commit]
git commit -m "type(scope): descriptive message

- Specific change 1
- Specific change 2"
```
Use conventional commit format:
- `fix` for bug fixes
- `feat` for new features
- `refactor` for code refactoring
- `docs` for documentation
- `test` for tests
- `chore` for build/config changes
- `style` for formatting

## Step 5: VERIFY COMMITS
After each commit, show:
```bash
git log --oneline -5
git status
```

## Guidelines
- NEVER commit unrelated changes together
- Each commit should have a single, clear purpose
- Keep commits small and focused (prefer 5-10 files max per commit)
- If changes are too intertwined, ask Lucy for guidance on how to separate them
- Always verify each commit builds/tests successfully if possible
- Write commit messages that explain WHY, not just WHAT

If $ARGUMENTS contains specific guidance (like "separate the API changes"), follow that direction.
