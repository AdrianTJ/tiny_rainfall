#!/bin/bash

# Improved Tiny Rain Simulator
# A more robust and visually appealing rain effect for the terminal.

# --- Configuration ---
COLOR_RAIN="\033[34m"     # Blue
COLOR_BRIGHT="\033[1;34m" # Bright Blue
COLOR_RESET="\033[0m"
COLOR_THUNDER="\033[107m" # Bright White Background
CHARACTERS=("." "," "'" "|" ":")
SPEED=0.05
DENSITY=20 # Higher = less rain (1 in X chance per column)

# Global State
cols=0
rows=0
buffer=()
THUNDER_ENABLED=false

# --- Functions ---

# Get terminal dimensions and re-initialize buffer
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

# Generate a single line of rain
generate_line() {
    local new_line=""
    for ((j=0; j<cols; j++)); do
        if ((RANDOM % DENSITY == 0)); then
            local char=${CHARACTERS[$RANDOM % ${#CHARACTERS[@]}]}
            if ((RANDOM % 5 == 0)); then
                new_line+="${COLOR_BRIGHT}${char}${COLOR_RESET}"
            else
                new_line+="${COLOR_RAIN}${char}${COLOR_RESET}"
            fi
        else
            new_line+=" "
        fi
    done
    echo "$new_line"
}

# Shift buffer and add new line
update_buffer() {
    for ((i=rows-1; i>0; i--)); do
        buffer[i]="${buffer[i-1]}"
    done
    buffer[0]=$(generate_line)
}

# Render the current buffer
draw_frame() {
    printf "\033[H"
    
    # Thunder flash
    if [[ "$THUNDER_ENABLED" == "true" ]] && (( RANDOM % 80 == 0 )); then
        printf "\033[107m\033[2J"
        sleep 0.03
    fi

    for ((i=0; i<rows; i++)); do
        printf "%b\n" "${buffer[i]}"
    done
    printf "%b" "${COLOR_RESET}"
}

# Main loop
main() {
    # Argument handling
    if [[ "$1" == "--thunder" || "$THUNDER" == "true" ]]; then
        THUNDER_ENABLED=true
    fi

    # Traps
    trap update_dimensions SIGWINCH
    trap cleanup SIGINT EXIT

    # Initial Setup
    tput civis # Hide cursor
    update_dimensions

    while :; do
        update_buffer
        draw_frame
        sleep $SPEED
    done
}

# Run main if not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
