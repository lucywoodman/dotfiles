---
name: dependabot-readiness
description: Audit a repository's readiness for automated Dependabot before running the dependabot-automation skill. Checks CI pipeline, branch protection, required status checks, and prerequisites.
allowed-tools: Bash(gh *), Bash(git *), Bash(ls *), Bash(cat *), Glob, Grep, Read, AskUserQuestion
argument-hint: [owner/repo]
---

# Dependabot Readiness Check

Audit a repository to determine if it's ready for automated Dependabot (auto-approve + auto-merge). This is a pre-flight check to run **before** the `dependabot-automation` skill.

## Step 0: Determine target repository

If `$ARGUMENTS` is provided, use it as `owner/repo`.

Otherwise, detect from the current working directory:

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

If neither works, ask the user for the repo.

Store the result as `REPO` for all subsequent steps.

## Step 1: Automated checks

Run all of the following checks. For each, record a verdict: PASS, FAIL, or WARN.

### 1a: GitHub CLI authentication

```bash
gh auth status 2>&1
```

Verdict: PASS if authenticated, FAIL if not (cannot proceed without it).

### 1b: Repository exists and is accessible

```bash
gh repo view $REPO --json name,defaultBranchRef --jq '.defaultBranchRef.name'
```

Record the default branch name for later checks. Verdict: PASS if accessible, FAIL if not.

### 1c: Branch protection enabled

```bash
gh api repos/$REPO/branches/$DEFAULT_BRANCH --jq '.protected'
```

Verdict: PASS if `true`, FAIL if `false`. Without branch protection, auto-merge has no gate.

### 1d: Required status checks

```bash
gh api repos/$REPO/branches/$DEFAULT_BRANCH/protection/required_status_checks --jq '.contexts[]' 2>&1
```

This may return 404 if the token lacks admin access. If so, fall back to empirical detection — look at recent merged PRs for consistent check names:

```bash
gh pr list --repo $REPO --state merged --limit 5 --json number,statusCheckRollup --jq '.[].statusCheckRollup[].name' | sort | uniq -c | sort -rn
```

Verdict:
- PASS if at least one required status check is configured or consistently appears on merged PRs
- FAIL if no checks are found at all
- WARN if checks exist but couldn't confirm they're *required* (admin access needed)

### 1e: CI pipeline exists

Look for CI configuration in the repo. Check for:

```bash
# GitHub Actions
gh api repos/$REPO/contents/.github/workflows --jq '.[].name' 2>/dev/null

# Cloud Build
gh api repos/$REPO/contents/cloudbuild.yaml 2>/dev/null || \
gh api repos/$REPO/contents/build/ci --jq '.[].name' 2>/dev/null

# Other CI
for f in .circleci/config.yml Jenkinsfile .travis.yml .gitlab-ci.yml; do
  gh api "repos/$REPO/contents/$f" --jq '.name' 2>/dev/null
done
```

Verdict: PASS if any CI config found, FAIL if none.

### 1f: CI runs on pull requests

Check whether any CI check has run on a recent PR:

```bash
gh pr list --repo $REPO --state merged --limit 3 --json number,statusCheckRollup --jq '.[].statusCheckRollup[] | .name + " (" + .conclusion + ")"'
```

Verdict:
- PASS if merged PRs show CI checks with conclusions
- FAIL if no checks appear on merged PRs
- WARN if all checks are "NEUTRAL" or non-blocking

### 1g: CI includes tests (not just build/lint)

Inspect CI config to determine if tests are run. If the repo is local, read the CI files directly. If remote, fetch content:

```bash
# For GitHub Actions workflows
gh api repos/$REPO/contents/.github/workflows --jq '.[].name' 2>/dev/null
```

Then for each workflow, check for test-related steps (look for keywords: `test`, `pytest`, `jest`, `go test`, `npm test`, `make test`, `cargo test`).

For Cloud Build or other CI, check the config files similarly.

Verdict:
- PASS if test execution is found in CI
- WARN if only linting/build found (no test step detected)
- FAIL if CI config has no recognizable test, lint, or build steps

### 1h: Required pull request reviews

```bash
gh api repos/$REPO/branches/$DEFAULT_BRANCH/protection/required_pull_request_reviews --jq '.required_approving_review_count' 2>&1
```

If 404 (no admin access), note this as uncheckable.

Verdict:
- PASS if at least 1 approval required
- WARN if couldn't check (no admin access) — auto-merge may still work if branch protection requires reviews
- INFO if 0 approvals required — auto-merge will work but there's no human review gate for non-Dependabot PRs

### 1i: Auto-merge enabled on repo

```bash
gh api repos/$REPO --jq '.allow_auto_merge'
```

Verdict:
- PASS if `true`
- INFO if `false` — the `dependabot-automation` skill can enable this automatically

### 1j: Existing Dependabot configuration

```bash
gh api repos/$REPO/contents/.github/dependabot.yml --jq '.name' 2>/dev/null || \
gh api repos/$REPO/contents/.github/dependabot.yaml --jq '.name' 2>/dev/null || \
echo "none"
```

Also check for existing automation workflows:

```bash
gh api repos/$REPO/contents/.github/workflows --jq '.[].name' 2>/dev/null | grep -i dependabot
```

Verdict:
- INFO if already configured — flag for user awareness, they may want to update rather than create
- INFO if not configured — expected state for a new setup

### 1k: CODEOWNERS file

```bash
gh api repos/$REPO/contents/.github/CODEOWNERS --jq '.name' 2>/dev/null || \
gh api repos/$REPO/contents/CODEOWNERS --jq '.name' 2>/dev/null || \
echo "none"
```

Verdict:
- INFO if CODEOWNERS exists — the `dependabot-automation` skill will need to handle this (Option A or B)
- INFO if no CODEOWNERS — simpler setup path

## Step 2: Present automated results

Format results as a report:

```
Dependabot Readiness: $REPO
===========================

## Automated Checks

PASS  GitHub CLI authenticated
PASS  Repository accessible (default branch: main)
PASS  Branch protection enabled
WARN  Required status checks — found checks on PRs but couldn't confirm required (need admin)
PASS  CI pipeline exists (Cloud Build)
PASS  CI runs on pull requests
PASS  CI includes tests
WARN  Required reviews — couldn't check (need admin access)
INFO  Auto-merge not enabled — dependabot-automation skill can enable this
INFO  No existing Dependabot config — ready for fresh setup
INFO  CODEOWNERS exists — will need machine user or exclusion approach
```

After the check table, provide a summary:

- **Ready**: All checks PASS (with INFO/WARN acceptable) — safe to run `/dependabot-automation`
- **Needs attention**: One or more WARN items that should be investigated
- **Not ready**: One or more FAIL items that must be resolved first

## Step 3: Manual checklist

After the automated results, present the decision checklist — items that require human judgement:

```
## Decision Checklist

Before running /dependabot-automation, confirm these items:

CI Quality
  - [ ] CI pipeline catches real breakages (not just cosmetic checks)
  - [ ] Test suite has meaningful coverage (not just smoke tests)
  - [ ] CI runs in a reasonable time (long CI delays Dependabot merges)

Security & Access
  - [ ] Machine user PAT available (if CODEOWNERS requires approval)
  - [ ] Team is comfortable with bot-approved dependency updates
  - [ ] Security scanning covers dependency vulnerabilities (e.g., Snyk, Dependabot alerts)

Operational
  - [ ] Team monitors for failed Dependabot PRs (they pile up if CI breaks)
  - [ ] Someone owns the process of reviewing major version updates
  - [ ] Release process can handle frequent small version bumps

Scope
  - [ ] Decided which ecosystems to include (gomod, npm, docker, github-actions, etc.)
  - [ ] Decided whether to ignore major versions (recommended: yes)
  - [ ] Decided on grouping strategy (single PR vs per-ecosystem)
```

## Step 4: Recommendation

Based on the automated checks and the context of the repo, give a clear recommendation:

1. **If ready**: "This repo looks ready for automated Dependabot. Run `/dependabot-automation` to set it up."
2. **If close**: "This repo is almost ready. Address these items first: [list]. Then run `/dependabot-automation`."
3. **If not ready**: "This repo needs more CI maturity before automated Dependabot. Specifically: [list blockers]."

## Guidelines

- This skill is **read-only** — it never modifies the repo, only inspects it
- Prefer `gh api` for remote checks so the skill works on any repo, not just local ones
- If a check fails due to permissions, degrade gracefully to WARN with an explanation
- Don't repeat what the `dependabot-automation` skill does — this skill diagnoses, that skill implements
- Keep the output scannable — the user should know in 10 seconds if the repo is ready
