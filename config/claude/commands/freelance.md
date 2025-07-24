Please analyze and implement the GitHub issue for freelance project: $ARGUMENTS.

Complete ALL of the following steps in sequence:

## Step 1: EXPLORE
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

## Step 2: PLAN
- Think harder about how to break the issue down into a series of small, manageable tasks
- Create a planning document: `~/notes/plans/$(date +%Y-%m-%d)-$ARGUMENTS-issue-title.md`
- Include the following in the planning document:
  - Issue number and title
  - Link to the GitHub issue
  - Client context and impact assessment
  - Problem analysis and understanding
  - Proposed approach and implementation strategy
  - Step-by-step breakdown of tasks
  - Delivery considerations and timeline
  - Any potential risks or considerations

## Step 3: CODE
- Create a new branch using format: `$ARGUMENTS-issue-title-with-hyphens`
- Solve the issue in small, manageable steps, according to your plan

## Step 4: COMMIT
- Commit your changes after each step, using a meaningful commit message that follows conventional commit format
- Include issue reference in commit messages for tracking

## Freelance Workflow Considerations

- **Client Communication**: Consider how changes affect client experience
- **Documentation**: Ensure changes are well-documented for client handover
- **Testing**: Verify functionality works as expected for end users
- **Deployment**: Consider client's deployment process and timeline

Remember to use the GitHub CLI (`gh`) for all GitHub-related tasks and maintain clear communication about progress and any blockers.
