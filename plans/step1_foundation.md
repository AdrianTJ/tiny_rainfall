# Step 1: Foundation & Testing

## Objective
Establish a robust testing environment and refactor the core script to be modular and verifiable.

## Tasks
1. **Testing Framework:** 
   - Research and integrate `bats-core` or a simple custom test runner.
   - Create a `tests/` directory.
2. **Refactoring:**
   - Extract `generate_line` and `update_buffer` into functions.
   - Ensure the script can be sourced without immediately running the loop (for unit testing).
3. **Initial Tests:**
   - Test `--thunder` flag detection.
   - Test `update_dimensions` mock outputs.

## Success Criteria
- Running `npm test` or `./run_tests.sh` passes.
- `rain.sh` functions are unit-testable.
