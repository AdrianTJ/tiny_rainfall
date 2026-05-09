#!/bin/bash

# Improved Tiny Rain Simulator - Final Stability Fix
# Focus: Maximum compatibility and zero syntax errors.

# --- Configuration ---
COLOR_RAIN="\033[34m"     # Blue
COLOR_BRIGHT="\033[1;34m" # Bright Blue
COLOR_RESET="\033[0m"
COLOR_THUNDER="\033[107m" # Bright White Background

# Using only safe characters to avoid shell parsing issues
CHARACTERS=("." "," ":" "i" "|")
SPLASH_CHAR="v"

SPEED=0.05
DENSITY=20 

# Global State
cols=0
rows=0
buffer=()
puddles=()
THUNDER_ENABLED=false

# --- Functions ---

# Get terminal dimensions and re-initialize state
update_dimensions() {
    cols=$(tput cols)
    rows=$(tput lines)
    buffer=()
    puddles=()
    local empty_line=$(printf "%${cols}s" "")
    for ((i=0; i<rows; i++)); do
        buffer[i]="$empty_line"
    done
    for ((i=0; i<cols; i++)); do
        puddles[i]=0
    done
}

# Cleanup on exit
cleanup() {
    tput cnorm # Show cursor
    echo -ne "\033[0m"
    clear
    exit
}

# Generate a single line of raw rain characters
generate_line() {
    local new_line=""
    for ((j=0; j<cols; j++)); do
        if ((RANDOM % DENSITY == 0)); then
            new_line+="${CHARACTERS[$RANDOM % ${#CHARACTERS[@]}]}"
        else
            new_line+=" "
        fi
    done
    echo "$new_line"
}

# Shift buffer and handle splashes and puddles
update_buffer() {
    # Shift buffer down
    for ((i=rows-1; i>0; i--)); do
        buffer[i]="${buffer[i-1]}"
    done

    # Splash & Puddle Logic
    local last_row="${buffer[rows-1]}"
    local new_last_row=""
    
    for ((j=0; j<cols; j++)); do
        char="${last_row:$j:1}"
        if [[ "$char" =~ [.,:i|] ]]; then
            # Increment puddle accumulation at this column
            ((puddles[j]++))
            # Show splash for one frame
            new_last_row+="$SPLASH_CHAR"
        else
            # If puddle exists here, show puddle character
            if (( puddles[j] > 10 )); then
                new_last_row+="~"
            elif (( puddles[j] > 0 )); then
                new_last_row+="_"
            else
                new_last_row+=" "
            fi
        fi
    done
    buffer[rows-1]="$new_last_row"
    
    # New top line
    buffer[0]=$(generate_line)
}

# Render the current buffer with optimized coloring
draw_frame() {
    # Move cursor to top-left
    printf "\033[H"
    
    # Thunder flash
    if [[ "$THUNDER_ENABLED" == "true" ]] && (( RANDOM % 80 == 0 )); then
        printf "\033[107m\033[2J"
        sleep 0.02
    fi

    local frame=""
    for ((i=0; i<rows; i++)); do
        local line="${buffer[i]}"
        
        # Fast coloring using pattern replacement
        if [[ "$line" == *[![:space:]]* ]]; then
            line="${line//./${COLOR_RAIN}.}"
            line="${line//,/${COLOR_RAIN},}"
            line="${line//:/${COLOR_RAIN}:}"
            line="${line//i/${COLOR_RAIN}i}"
            line="${line//|/${COLOR_RAIN}|}"
            line="${line//$SPLASH_CHAR/${COLOR_BRIGHT}${SPLASH_CHAR}}"
            line="${line//~/${COLOR_BRIGHT}~}"
            line="${line//_/${COLOR_RAIN}_}"
            line="${line}${COLOR_RESET}"
        fi
        
        # Avoid newline on the very last row to prevent scrolling
        if (( i < rows - 1 )); then
            frame+="$line\n"
        else
            frame+="$line"
        fi
    done
    
    printf "%b" "$frame"
}

# Main loop
main() {
    if [[ "$1" == "--thunder" || "$THUNDER" == "true" ]]; then
        THUNDER_ENABLED=true
    fi

    trap update_dimensions SIGWINCH
    trap cleanup SIGINT EXIT

    tput civis
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
