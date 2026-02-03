---
name: review-changes
description: Analyze changes for patterns, compare with existing code, and build pattern documentation
---

I need you to analyze my changes for patterns and help build pattern knowledge for this codebase.

## Step 1: Understand what patterns are involved

Show me what's being changed:

- Run `git diff --staged` (or `git diff` if nothing is staged)
- Identify what patterns or approaches these changes use:
  - Database queries and ORM usage
  - API endpoint implementations and routing
  - Authentication/authorization
  - Error handling approaches
  - Validation patterns
  - Service/repository layer patterns
  - Configuration and dependency injection
  - UI components or templates
  - Business logic organization

## Step 2: Search for similar patterns in the codebase

For each significant pattern in my changes, search the codebase to find:

- Similar implementations or patterns that already exist
- How this type of problem is typically solved in this codebase
- Any inconsistencies with existing approaches
- **Multiple conflicting patterns** for the same thing (this is critical to flag!)

For each pattern you find:

- Show 2-3 concrete examples from the codebase with file paths and line numbers
- Compare my changes against these existing patterns
- Note if my changes follow, diverge from, or improve upon existing patterns
- **Flag if existing pattern is problematic** (doesn't follow good practices, is buggy, has security issues, etc.)

## Step 3: Evaluate pattern quality

For each pattern (both my changes and existing code):

- Does it follow good coding practices?
- Are there better approaches we should be using?
- Are there bugs or security issues?
- Is it maintainable and clear?
- Does it handle edge cases appropriately?

If my changes follow a bad existing pattern, suggest a better approach.
If my changes introduce a new/better pattern, highlight that.

## Step 4: Check pattern documentation

Look for existing pattern documentation:

- Check for `PATTERNS.md`, `CONVENTIONS.md`, `docs/patterns/`, `docs/architecture/`, or similar
- Check if there's relevant documentation for the patterns involved
- Note any gaps where patterns exist but aren't documented
- Identify if conflicting patterns are documented (or if neither are documented)

## Step 5: Pattern documentation recommendations

Suggest what should be documented or updated:

### If establishing a new pattern:
- Propose adding it to PATTERNS.md (or creating PATTERNS.md if it doesn't exist)
- Include concrete examples from the codebase
- Explain when to use this pattern and why
- Document any trade-offs or gotchas

### If a pattern exists but isn't documented:
- Suggest documenting the established pattern
- Include examples showing the pattern in use
- Note any variations or edge cases found

### If multiple conflicting patterns exist:
- Flag this as a **HIGH PRIORITY** standardization opportunity
- Suggest which pattern should be preferred and why
- Propose documenting the preferred approach
- Note files that should be migrated to the preferred pattern

### If my changes improve upon a bad pattern:
- Document the new improved pattern
- Explain why it's better than the old approach
- Suggest migrating other code to this pattern over time

## Output format

Keep the output structured and scannable:

**Patterns Found:**
- [Pattern type]: [Description]
  - My changes: [file:line]
  - Existing examples: [file:line, file:line]
  - Assessment: [follows/diverges/improves/new pattern]
  - Quality: [good/problematic - explain why]

**Conflicts & Issues:**
- [HIGH PRIORITY] [Description of conflict or issue]

**Documentation Recommendations:**
- [ ] Add to PATTERNS.md: [what to add]
- [ ] Update existing docs: [what to change]
- [ ] Create new pattern doc: [for what pattern]

Be specific with file paths and line numbers.
Flag HIGH PRIORITY items for conflicting patterns or problematic code being replicated.

Remember: This is for legacy applications without established patterns. The goal is to learn from existing code, identify what works and what doesn't, and gradually build standards that reflect the actual codebase rather than imposing external conventions.
