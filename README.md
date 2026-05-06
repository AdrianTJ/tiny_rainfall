### Tiny Rain Simulator

**Description:**
A lightweight Bash script that simulates a rain effect in your terminal. This improved version features smooth animations, color depth, and robust terminal handling.

**Key Features:**
- **Visual Depth:** Uses varying blue tones and a mix of characters (`.`, `,`, `'`, `|`, `:`) to create a more immersive effect.
- **Graceful Exit:** Cleans up the terminal, restores the cursor, and resets colors when you stop the script.
- **Dynamic Resizing:** Automatically adapts to terminal window resizing.
- **Minimal Flicker:** Uses efficient cursor positioning for a smoother experience.
- **Thunder Effect:** Optional lightning flashes for a stormier feel.

**Usage:**
1. **Save the script:** Save the code as `rain.sh`.
2. **Make it executable:**
   ```bash
   chmod +x rain.sh
   ```
3. **Run the script:**
   ```bash
   ./rain.sh
   ```
   To enable thunder (lightning flashes):
   ```bash
   ./rain.sh --thunder
   # OR
   THUNDER=true ./rain.sh
   ```
   Press `Ctrl+C` to stop the simulation.

**Customization:**
Open `rain.sh` to adjust these variables at the top of the file:
- `SPEED`: Change the sleep time (default `0.05`) to speed up or slow down the rain.
- `DENSITY`: Adjust the frequency of raindrops (lower values = more rain).
- `COLOR_RAIN`: Change the ANSI color codes to customize the look (e.g., green for a Matrix effect).

**Note:** This script is designed for standard terminal environments. It requires `tput` (included in most Linux/macOS distributions).
