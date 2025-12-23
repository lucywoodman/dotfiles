name: review-principles
description: Review changes against YAGNI, DRY, and over-engineering principles
prompt: |
  Review the changes in this branch compared to the default branch and evaluate them for coding principle violations and unnecessary complexity.

  ## Step 1: Get the changes

  Run `git diff main...HEAD` (or appropriate base branch) to see all changes in this branch.

  ## Step 2: Analyze for principle violations

  Evaluate the changes for:

  ### YAGNI Violations (You Aren't Gonna Need It)
  - Features added for hypothetical future requirements
  - Configuration options for scenarios that don't exist yet
  - Abstractions or interfaces with only one implementation
  - Flexibility/extensibility beyond current needs
  - Feature flags or versioning for things not yet needed

  ### Over-Engineering
  - Unnecessary complexity beyond the task requirements
  - Premature abstractions (helpers, utilities, base classes for one-time use)
  - Excessive layers or indirection
  - Design patterns used where simple code would work
  - Framework-like solutions for specific problems

  ### False DRY (Don't Repeat Yourself)
  - Creating abstractions for 2-3 similar lines
  - Consolidating code that just happens to look similar but serves different purposes
  - Introducing coupling to avoid surface-level duplication

  ### True DRY Issues
  - Actual logic duplication that should be consolidated
  - Copy-pasted code blocks that will need to change together
  - Duplicated business rules or validations

  ### Scope Creep
  - Refactoring code not related to the stated goal
  - Adding comments/docs to unchanged code
  - "Cleanup" or "improvements" beyond the task
  - Type annotations or error handling for code not being changed

  ### Backwards Compatibility Hacks
  - Renaming unused variables with underscore prefixes
  - Re-exporting types or functions that should be deleted
  - `// removed` comments for deleted code
  - Keeping dead code "just in case"

  ## Step 3: For each issue found

  Report using this format:

  **[SEVERITY] [Principle]: [Brief description]**
  - File: `path/to/file.ts:123`
  - Issue: [Quote or describe the problematic code]
  - Why: [Explain the violation]
  - Fix: [Suggest simpler alternative]

  Severity levels:
  - 🔴 **Significant**: Major over-engineering or complexity
  - 🟡 **Moderate**: Noticeable but not critical
  - 🟢 **Minor**: Small issue, easy to fix

  ## Step 4: Highlight good decisions

  Also call out where the code does the right thing:

  **✅ Good Decision: [What was avoided]**
  - Where: `path/to/file.ts:123`
  - Why good: [Explain what simpler choice was made]

  ## Step 5: Summary

  Provide a final verdict:
  - **Overall assessment**: Over-engineered / Appropriately simple / Could be simpler
  - **Must fix**: [List significant issues]
  - **Consider**: [List moderate issues]
  - **Total complexity score**: [Simple/Moderate/Complex/Over-engineered]

  ## Guidelines

  - Be specific with file paths and line numbers
  - Quote actual code where helpful
  - Focus on what was added/changed, not existing code
  - Remember: Simple > Clever, YAGNI by default
  - Three similar lines is better than a premature abstraction
  - Only validate at system boundaries (user input, external APIs)
  - Don't flag missing error handling for scenarios that can't happen

  Be direct and honest. The goal is to keep code simple and focused.
