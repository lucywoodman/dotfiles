Please analyse ticket and create a plan: $ARGUMENTS

## Step 1: DETECT CONTEXT
- If $ARGUMENTS looks like "SRET-XXX" format → Use Jira workflow
- If $ARGUMENTS is just a number → Use GitHub workflow
- Otherwise → Use general problem workflow

## Step 2: EXPLORE

### For Jira Issues (SRET-XXX format):
1. Use `acli jira workitem view $ARGUMENTS` to get the ticket details
2. Understand the problem described in the ticket
3. Ask clarifying questions if necessary
4. Understand the prior art for this ticket:
   - Search the scratchpads for previous thoughts related to the ticket
   - Search git history to see if you can find related work
   - Search the codebase for relevant files

### For GitHub Issues (numeric format):
1. Use GitHub CLI to get the issue details:
   ```bash
   gh issue view $ARGUMENTS --json title,body,state,url,number,labels,assignees
   ```
2. Understand the problem described in the issue
3. Ask clarifying questions if necessary
4. Understand the prior art for this issue:
   - Search the scratchpads for previous thoughts related to the issue
   - Search git history to see if you can find related work
   - Search the codebase for relevant files

### For General Problems:
1. Understand the problem described
2. Ask clarifying questions if necessary
3. Understand the prior art for this problem:
   - Search the scratchpads for previous thoughts related to the problem
   - Search git history to see if you can find related work
   - Search the codebase for relevant files

## Step 3: ANALYZE & PLAN
- Think deeply about the problem and how to break it down
- **Propose 2-3 different approaches** with trade-offs and architectural reasoning
- Create a planning document in `~/notes/plans/` using appropriate format:
  - **Jira**: `$(date +%Y-%m-%d)-$ARGUMENTS-ticket-title.md`
  - **GitHub**: `$(date +%Y-%m-%d)-$ARGUMENTS-issue-title.md`
  - **General**: `$(date +%Y-%m-%d)-problem-description.md`

### Planning Document Contents:
- Problem/ticket/issue ID and title (if applicable)
- Link to the ticket/issue (if applicable)
- **Client context and impact assessment** (for freelance work)
- Problem analysis and understanding
- **2-3 proposed approaches with pros/cons**
- **Architectural reasoning and approach justification**
- Recommended approach and implementation strategy
- Step-by-step breakdown of tasks
- **What we learned during exploration**
- Potential risks or considerations
- **Delivery considerations and timeline** (for freelance work)

## Learning Focus
Throughout the process:
- Connect decisions to architectural principles
- Explain trade-offs and alternatives considered
- Challenge assumptions and explore edge cases
- Document insights for future reference
