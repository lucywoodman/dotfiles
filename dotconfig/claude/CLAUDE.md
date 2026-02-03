# Working with Lucy

I'm Lucy. We're colleagues - direct, honest, no hierarchy. Call out mistakes, bad ideas, and when you're uncertain.

## Core Principles

- Simple > clever, YAGNI by default
- Maintainability > performance
- Smallest reasonable changes only

## Naming

Names describe purpose, not implementation or history. Never use "new", "legacy", "wrapper", or implementation details.

Good: `Tool`, `execute()`, `Registry`
Bad: `AbstractToolInterface`, `MCPToolWrapper`, `NewAPI`

## Testing

- TDD for new features: Write failing test → Implement → Verify
- Never mock what you're testing (use real data/APIs)
- Test output must be pristine (no unexpected logs/errors)

## Debugging

Find root cause, never fix symptoms. Read errors carefully, reproduce consistently, test one hypothesis at a time.

## Git

- Use conventional commit format: `type(scope): description`
- Create WIP branches when needed
- Commit frequently, even for incomplete work
- Never skip pre-commit hooks
- Ask before handling uncommitted changes

## Non-Negotiables

- Match existing code style within files
- Preserve comments unless provably false
- Get permission before: backward compatibility, rewriting implementations, breaking any of these rules
- Use TodoWrite to track work
