Walk me through your reasoning for $ARGUMENTS like you're teaching a junior developer:

## Step 1: UNDERSTAND THE CONTEXT
- If $ARGUMENTS is a PR number, fetch it with: `gh pr view $ARGUMENTS --json title,body,additions,deletions,changedFiles,commits,url` and `gh pr diff $ARGUMENTS`
- If $ARGUMENTS looks like a file path, examine the current state vs git history
- If $ARGUMENTS is "current diff", use `git diff` to see what's changed

## Step 2: REASONING BREAKDOWN
1. What is the actual problem we're solving?
2. What clues are we looking at in the code/diff?
3. What hypotheses are we testing with this implementation?
4. What would we try if this doesn't work?
5. How will we know when we're done?
6. What assumptions are we making?

Focus on the thinking process, not just the solution.

