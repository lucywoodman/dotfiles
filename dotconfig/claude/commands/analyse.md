Please analyse and implement: $ARGUMENTS

## Step 1: DETECT CONTEXT
- If $ARGUMENTS looks like "SRET-XXX" format → Use Jira workflow
- If $ARGUMENTS is just a number → Use GitHub workflow  
- Otherwise → Use general problem workflow

## Step 2: EXPLORE (with learning focus)

### For Jira Issues (SRET-XXX format):
1. Use `acli jira workitem view $ARGUMENTS` to get the ticket details
2. Understand the problem described in the ticket
3. Ask clarifying questions if necessary
4. **Ask me to explain the reasoning** behind any architectural decisions before implementing
5. **Propose 2-3 different approaches** with trade-offs before choosing one
6. Understand the prior art for this ticket:
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
4. **Ask me to explain the reasoning** behind any architectural decisions before implementing
5. **Propose 2-3 different approaches** with trade-offs before choosing one
6. Understand the prior art for this issue:
   - Search the scratchpads for previous thoughts related to the issue
   - Search git history to see if you can find related work
   - Search the codebase for relevant files

### For General Problems:
1. Understand the problem described
2. Ask clarifying questions if necessary
3. **Ask me to explain the reasoning** behind any architectural decisions before implementing
4. **Propose 2-3 different approaches** with trade-offs before choosing one
5. Understand the prior art for this problem:
   - Search the scratchpads for previous thoughts related to the problem
   - Search git history to see if you can find related work
   - Search the codebase for relevant files

## Step 2: PLAN
- Think harder about how to break the problem down into a series of small, manageable tasks
- Create a planning document using appropriate format:
  - **Jira**: `~/notes/plans/$(date +%Y-%m-%d)-$ARGUMENTS-ticket-title.md`
  - **GitHub**: `~/notes/plans/$(date +%Y-%m-%d)-$ARGUMENTS-issue-title.md`
  - **General**: `~/notes/plans/$(date +%Y-%m-%d)-problem-description.md`

### Planning Document Contents:
- Problem/ticket/issue ID and title (if applicable)
- Link to the ticket/issue (if applicable)
- **Client context and impact assessment** (for freelance work)
- Problem analysis and understanding
- **Architectural reasoning and approach justification**
- Proposed approach and implementation strategy
- Step-by-step breakdown of tasks
- **What we learned during exploration**
- Any potential risks or considerations
- **Delivery considerations and timeline** (for freelance work)

## Step 3: CODE
- Create a new branch using appropriate format:
  - **Jira**: `$ARGUMENTS-ticket-title-with-hyphens`
  - **GitHub**: `$ARGUMENTS-issue-title-with-hyphens`
  - **General**: `description-of-problem`
- Solve the problem in small, manageable steps, according to your plan
- **Explain your reasoning for each significant implementation decision**

## Step 4: COMMIT
- Commit your changes after each step
- Use meaningful commit messages that follow conventional commit format
- Include issue/ticket reference in commit messages for tracking (where applicable)

## Workflow Considerations

### For Freelance Work:
- **Client Communication**: Consider how changes affect client experience
- **Documentation**: Ensure changes are well-documented for client handover
- **Testing**: Verify functionality works as expected for end users
- **Deployment**: Consider client's deployment process and timeline

### For Corporate Work:
- Remember to use the Atlassian CLI (`acli`) for all Jira-related tasks
- Follow team standards and review processes

### For General Problems:
- Document learnings and patterns discovered
- Consider how solution fits into broader system architecture

## Learning Focus
Throughout the process:
- Connect decisions to architectural principles
- Explain trade-offs and alternatives considered
- Document insights for future reference
- Challenge assumptions and explore edge cases
