Create a pull request for the current branch: $ARGUMENTS

## Step 1: GATHER CONTEXT
```bash
# Get current branch info
git branch --show-current
git log --oneline main..HEAD

# Check if there's a PR template
ls .github/pull_request_template.md 2>/dev/null || ls .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null || echo "No template found"
```

## Step 2: ANALYSE CHANGES
Understand what this PR does:
```bash
# Show files changes
git diff --name-only main..HEAD

# Show actual changes
git diff main..HEAD
```

## Step 3: CHECK FOR EXISTING TEMPLATE
If template exists, use it. Otherwise, use the standard template below.

## Step 4: GENERATE DESCRIPTION
Based on the commits and changes, create a description using this template:
```md
## Summary
<!-- Brief description of what this PR does -->

## Related Issues
<!-- Link to Jira ticket or GitHub issue -->

## Changes
<!-- What was changed and why -->

## Testing
<!-- How was this tested? -->
```

Fill in each section based on:
- *Summary:* One-line description of the main change
- *Related Issues:* Extract any issue/ticket references from commits or $ARGUMENTS
- *Changes:* Bullet points of key changes, derived from commit messages and diff analysis
- *Testing:* Mention test files changed, or note if manual testing was done

## Step 5: CREATE THE PR
```bash
gh pr create --title "Appropriate title based on changes" --body "Generated description"
```

## Step 6: VERIFY AND ENHANCE
After creating:
```bash
# Show the created PR
gh pr view --web
```

## GUIDELINES
- Title should be concise but descriptive
- Extract issue numbers from commit messages or branch names when possible
- If $ARGUMENTS contains a title or description, use that
- If multiple unrelated changes, suggest splitting into separate PRs
- Always mention if this is a breaking change
- Include deployment notes if relevant
- If changes affect APIs, mention backward compatibility

