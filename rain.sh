#!/bin/bash

# Improved Tiny Rain Simulator
# A more robust and visually appealing rain effect for the terminal.

# Configuration
COLOR_RAIN="\033[34m"     # Blue
COLOR_BRIGHT="\033[1;34m" # Bright Blue
COLOR_RESET="\033[0m"
CHARACTERS=("." "," "'" "|" ":")
SPEED=0.05
DENSITY=20 # Higher = less rain (1 in X chance per column)

# Get terminal dimensions
update_dimensions() {
    cols=$(tput cols)
    rows=$(tput lines)
    # Re-initialize buffer to avoid alignment issues on resize
    buffer=()
    for ((i=0; i<rows; i++)); do buffer[i]=""; done
}

# Cleanup on exit
cleanup() {
    tput cnorm # Show cursor
    echo -ne "${COLOR_RESET}"
    clear
    exit
}

# Traps
trap update_dimensions SIGWINCH
trap cleanup SIGINT EXIT

# Initial Setup
tput civis # Hide cursor
update_dimensions

while :; do
    # Shift buffer lines down
    for ((i=rows-1; i>0; i--)); do
        buffer[i]="${buffer[i-1]}"
    done

    # Generate new top line
    new_line=""
    for ((j=0; j<cols; j++)); do
        if ((RANDOM % DENSITY == 0)); then
            char=${CHARACTERS[$RANDOM % ${#CHARACTERS[@]}]}
            # Occasionally use bright color for depth
            if ((RANDOM % 5 == 0)); then
                new_line+="${COLOR_BRIGHT}${char}${COLOR_RESET}"
            else
                new_line+="${COLOR_RAIN}${char}${COLOR_RESET}"
            fi
        else
            new_line+=" "
        fi
    done
    buffer[0]="$new_line"

    # Draw the frame
    # Move cursor to top-left
    printf "\033[H"
    for ((i=0; i<rows; i++)); do
        # Use %b to interpret the color escape codes in the buffer
        printf "%b\n" "${buffer[i]}"
    done

    sleep $SPEED
done
