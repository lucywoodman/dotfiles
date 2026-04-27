---
name: sonarqube-readiness
description: Audit a repository's readiness for SonarQube static analysis integration. Checks for existing config, CI pipeline integration, coverage reporting, and prerequisites for connecting to $SONAR_HOST_URL.
allowed-tools: Bash(gh *), Bash(git *), Bash(ls *), Bash(cat *), Glob, Grep, Read, AskUserQuestion
argument-hint: [owner/repo]
---

# SonarQube Readiness Check

Audit a repository to determine if it's ready for SonarQube static analysis integration with `$SONAR_HOST_URL`. Checks existing configuration, CI integration points, and coverage reporting.

## Step 0: Determine target repository

If `$ARGUMENTS` is provided, use it as `owner/repo`.

Otherwise, detect from the current working directory:

```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

If neither works, ask the user for the repo.

Store the result as `REPO` for all subsequent steps.

## Step 1: Automated checks

Run all of the following checks. For each, record a verdict: PASS, FAIL, WARN, or INFO.

### 1a: Detect primary language and ecosystem

Determine the repo's primary language:

```bash
gh api repos/$REPO --jq '.language'
```

Also check for specific build files to refine detection:

```bash
# Go
gh api repos/$REPO/contents/go.mod --jq '.name' 2>/dev/null

# JavaScript/TypeScript
gh api repos/$REPO/contents/package.json --jq '.name' 2>/dev/null

# Python
for f in requirements.txt setup.py pyproject.toml Pipfile; do
  gh api "repos/$REPO/contents/$f" --jq '.name' 2>/dev/null
done

# Java
for f in pom.xml build.gradle build.gradle.kts; do
  gh api "repos/$REPO/contents/$f" --jq '.name' 2>/dev/null
done
```

Record the language — this determines which SonarQube properties and coverage formats to expect. Verdict: INFO (always passes, just records context).

### 1b: Existing sonar-project.properties

```bash
gh api repos/$REPO/contents/sonar-project.properties --jq '.name' 2>/dev/null || echo "none"
```

If found and the repo is local, read it to check configuration completeness:

- `sonar.projectKey` — required, unique project identifier
- `sonar.projectName` — required, display name
- `sonar.host.url` — should point to `$SONAR_HOST_URL`
- `sonar.sources` — source directories
- `sonar.exclusions` — files/dirs excluded from analysis
- `sonar.tests` / `sonar.test.inclusions` — test file identification
- Coverage report path (language-specific, e.g., `sonar.go.coverage.reportPaths`)

Verdict:
- PASS if file exists with `projectKey`, `projectName`, and `host.url` configured
- WARN if file exists but missing key fields
- INFO if no file exists — needs creation

### 1c: CI pipeline exists and includes SonarQube step

Check for SonarQube integration in CI:

```bash
# GitHub Actions — search for sonar in workflow files
gh api repos/$REPO/contents/.github/workflows --jq '.[].name' 2>/dev/null
```

For each workflow, check for sonar-related steps. If the repo is local, search directly:

```bash
grep -rl -i 'sonar' .github/workflows/ build/ci/ 2>/dev/null
```

Look for common SonarQube CI patterns:
- `sonar-scanner-cli` container/action
- `SonarSource/sonarqube-scan-action` GitHub Action
- `sonar-scanner` CLI invocation
- References to `SONAR_TOKEN` or `SONAR_HOST_URL`

Verdict:
- PASS if SonarQube scan step found in CI
- FAIL if no SonarQube integration in any CI config

### 1d: SonarQube scan runs after tests

If a SonarQube step is found, verify ordering — the scan should run after tests so it can pick up coverage data.

For Cloud Build, check `waitFor` dependencies. For GitHub Actions, check step ordering or `needs`.

Verdict:
- PASS if scan depends on or follows test step
- WARN if ordering is unclear or scan runs in parallel with tests
- INFO if couldn't determine ordering

### 1e: Coverage report generation

Check if the CI pipeline generates a coverage report that SonarQube can consume.

Look for coverage-related commands in CI config:

| Language | Coverage command patterns | Report format |
|---|---|---|
| Go | `-coverprofile=`, `go tool cover` | `coverage.out` (Go cover format) |
| JS/TS | `--coverage`, `jest --coverage`, `nyc`, `c8` | `lcov.info` or Clover XML |
| Python | `pytest --cov`, `coverage run` | `coverage.xml` (Cobertura) |
| Java | `jacoco`, `maven surefire` | JaCoCo XML |

Verdict:
- PASS if coverage report generation found in CI
- WARN if tests run but no coverage output detected
- INFO if couldn't determine (suggest manual check)

### 1f: Coverage report path matches sonar config

If both `sonar-project.properties` and coverage generation exist, verify the report path in sonar config matches what CI produces.

Common sonar properties by language:
- Go: `sonar.go.coverage.reportPaths`
- JS/TS: `sonar.javascript.lcov.reportPaths`
- Python: `sonar.python.coverage.reportPaths`
- Java: `sonar.coverage.jacoco.xmlReportPaths`

Verdict:
- PASS if paths align
- WARN if paths look mismatched
- INFO if couldn't determine

### 1g: SONAR_TOKEN secret configured

Check if the SonarQube token is available as a secret:

```bash
# GitHub Actions secrets (can't read values, just check if referenced)
# Check if any workflow references SONAR_TOKEN
grep -r 'SONAR_TOKEN' .github/workflows/ 2>/dev/null

# Cloud Build secrets
grep -r 'sonar_token' build/ci/ 2>/dev/null
```

Verdict:
- PASS if `SONAR_TOKEN` is referenced in CI config
- FAIL if no token reference found — scan will fail without auth

### 1h: Source and test exclusions configured

If `sonar-project.properties` exists and is readable, check that exclusions are sensible:

- Generated code excluded (e.g., `**/mocks/**`, `**/gen/**`, `**/*.pb.go`)
- Test files excluded from source analysis
- Vendor/dependency dirs excluded (e.g., `vendor/**`, `node_modules/**`)
- Build artifacts excluded

Verdict:
- PASS if exclusions are configured and look reasonable
- WARN if no exclusions configured (noisy results likely)
- INFO if no sonar config file to check

### 1i: PR decoration configured

Check if the CI SonarQube step passes PR metadata for PR decoration (inline comments on PRs):

Look for these parameters in the CI config:
- `sonar.pullrequest.key`
- `sonar.pullrequest.branch`
- `sonar.pullrequest.base`

Verdict:
- PASS if PR parameters are passed to scanner
- WARN if SonarQube runs but without PR metadata (no inline comments on PRs)
- INFO if no SonarQube step found

### 1j: Quality gate as required check

Check if SonarQube analysis appears as a status check on PRs:

```bash
gh pr list --repo $REPO --state merged --limit 5 --json number,statusCheckRollup --jq '.[].statusCheckRollup[].name' | grep -i sonar
```

Verdict:
- PASS if "SonarQube" check appears on merged PRs
- WARN if SonarQube runs in CI but doesn't report as a separate check
- INFO if no SonarQube integration yet

## Step 2: Present automated results

Format results as a report:

```
SonarQube Readiness: $REPO
==========================

## Automated Checks

INFO  Primary language: Go (go.mod detected)
PASS  sonar-project.properties exists and configured
PASS  SonarQube scan step in CI (Cloud Build)
PASS  Scan runs after tests (waitFor: run tests)
PASS  Coverage report generated (output/coverage.out)
PASS  Coverage path matches sonar config
PASS  SONAR_TOKEN referenced in CI
PASS  Source/test exclusions configured
PASS  PR decoration configured (pullrequest.key/branch/base)
PASS  SonarQube appears as PR status check
```

After the check table, provide a summary:

- **Ready**: All checks PASS — SonarQube is well integrated
- **Partially configured**: Some WARN items that should be addressed
- **Not configured**: FAIL items or no SonarQube integration present — needs setup

## Step 3: Manual checklist

Present the decision checklist for items requiring human judgement:

```
## Decision Checklist

SonarQube Server
  - [ ] Project exists on $SONAR_HOST_URL (or needs to be created)
  - [ ] Quality gate configured (default or custom)
  - [ ] Quality profiles assigned for the project's language(s)

Coverage & Analysis
  - [ ] Coverage exclusions match what makes sense for this repo
  - [ ] Issue exclusions configured for acceptable patterns (e.g., test files)
  - [ ] New code definition set (reference branch or number of days)

CI Integration
  - [ ] SONAR_TOKEN secret is set and valid (not expired)
  - [ ] Scanner version pinned (not using :latest)
  - [ ] Scan timeout is reasonable for the codebase size

Team & Process
  - [ ] Team knows how to view results on $SONAR_HOST_URL
  - [ ] Someone owns quality gate failures (not just ignored)
  - [ ] PR decoration is useful (not generating noise)
```

## Step 4: Recommendation

Based on the automated checks, give a clear recommendation:

1. **If fully configured**: "SonarQube is well integrated in this repo. All key components are in place."
2. **If partially configured**: "SonarQube has a foundation but these items need attention: [list]. Key gap: [most impactful missing piece]."
3. **If not configured**: "SonarQube is not yet integrated. To set it up, you'll need: [ordered list of steps]."

When not configured, provide a setup order:

```
Setup Order:
1. Create project on $SONAR_HOST_URL
2. Generate SONAR_TOKEN and add as CI secret
3. Create sonar-project.properties with project key, sources, and exclusions
4. Add coverage generation to test step (if not already present)
5. Add sonar-scanner step to CI (after tests)
6. Add PR decoration parameters for inline feedback
7. Optionally: add SonarQube as a required status check
```

## Guidelines

- This skill is **read-only** — it never modifies the repo, only inspects it
- Prefer `gh api` for remote checks so the skill works on any repo, not just local ones
- If a check fails due to permissions, degrade gracefully to WARN with an explanation
- The reference implementation is `$SONAR_REFERENCE_REPO` — use it as the gold standard for what "well configured" looks like
- SonarQube server is at `$SONAR_HOST_URL`
- Keep the output scannable — the user should know in 10 seconds if the repo is ready
