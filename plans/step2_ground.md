# Step 2: Ground Splashes & Puddles

## Objective
Add "physical" interaction where raindrops hit the bottom of the terminal.

## Tasks
1. **Splash Logic:**
   - Detect when a raindrop character reaches the last row.
   - Replace the character with a splash symbol (`v`, `u`, or `_`) for one frame.
2. **Puddle Accumulation:**
   - Maintain a "puddle" state across the bottom row.
   - Slowly fill the bottom row with `~` or `_` characters as rain falls.
3. **Testing:**
   - Unit test the "hit detection" logic.
   - Verify puddle height doesn't exceed 1 row (for now).

## Success Criteria
- Raindrops visually "splash" before disappearing.
- A puddle line gradually forms at the bottom.
