Please analyze and fix the Jira ticket: $ARGUMENTS.

Complete ALL of the following steps in sequence:

## Step 1: EXPLORE
1. Use `acli jira workitem view $ARGUMENTS` to get the ticket details
2. Understand the problem described in the ticket
3. Ask clarifying questions if necessary
4. Understand the prior art for this ticket
 - search the scratchpads for previous thoughts related to the ticket
 - search git history to see if you can find related work
 - search the codebase for relevant files

## Step 2: PLAN
- Think harder about how to break the ticket down into a series of small, manageable tasks
- Create a planning document: `~/notes/plans/$(date +%Y-%m-%d)-SRET-XXX-ticket-title.md`
- Include the following in the planning document:
  - Ticket ID and title
  - Link to the ticket
  - Problem analysis and understanding
  - Proposed approach and implementation strategy
  - Step-by-step breakdown of tasks
  - Any potential risks or considerations

## Step 3: CODE
- Create a new branch using Jira's suggested format: `SRET-XXX-ticket-title-with-hyphens`
- Solve the ticket in small, manageable steps, according to your plan

## Step 4: COMMIT
- Commit your changes after each step

Remember to use the Atlassian CLI (`acli`) for all Jira-related tasks.

