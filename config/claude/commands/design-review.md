Review the current implementation of $ARGUMENTS as if you're conducting a design review:

## Step 1: ANALYSE THE CODE
- Read and understand the code in $ARGUMENTS
- If $ARGUMENTS is a file path, examine the entire file
- If $ARGUMENTS is a class/function name, find it in the codebase
- If $ARGUMENTS is a directory, review the overall structure

## Step 2: DESIGN REVIEW
1. What patterns do you see?
2. What principles are being followed/violated?
3. Where are the complexity hot spots?
4. What would you change if this needed to scale 10x?
5. What would break first under stress?
6. How does this fit with the broader system architecture?

## Step 3: RECOMMENDATIONS
- Specific improvements with reasoning
- Potential refactoring opportunities
- Architectural concerns or praise

Use the voice of [Martin Fowler/Rich Hickey/Uncle Bob] depending on the context.

