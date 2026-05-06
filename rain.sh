#!/bin/bash

# Improved Tiny Rain Simulator
# A more robust and visually appealing rain effect for the terminal.

# --- Configuration ---
COLOR_RAIN="\033[34m"     # Blue
COLOR_BRIGHT="\033[1;34m" # Bright Blue
COLOR_PUDDLE="\033[36m"   # Cyan
COLOR_RESET="\033[0m"
COLOR_THUNDER="\033[107m" # Bright White Background

CHARACTERS=("." "," "'" "|" ":")
SPLASH_CHARS=("v" "u" "w")
PUDDLE_CHAR="~"

SPEED=0.05
DENSITY=20 # Higher = less rain (1 in X chance per column)

# Global State
cols=0
rows=0
buffer=()
puddle=() # Tracks accumulation per column
THUNDER_ENABLED=false

# --- Functions ---

# Get terminal dimensions and re-initialize state
update_dimensions() {
    cols=$(tput cols)
    rows=$(tput lines)
    buffer=()
    puddle=()
    for ((i=0; i<rows; i++)); do buffer[i]=$(printf "%${cols}s" ""); done
    for ((j=0; j<cols; j++)); do puddle[j]=0; done
}

# Cleanup on exit
cleanup() {
    tput cnorm # Show cursor
    echo -ne "${COLOR_RESET}"
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

# Shift buffer and handle splashes/puddles
update_buffer() {
    # Shift buffer down
    for ((i=rows-1; i>0; i--)); do
        buffer[i]="${buffer[i-1]}"
    done

    # Handle Ground Row (rows-1)
    local ground=""
    local prev_row="${buffer[rows-1]}"
    
    for ((j=0; j<cols; j++)); do
        local char="${prev_row:$j:1}"
        
        # If there was a raindrop here, it "splashes" and adds to puddle
        if [[ "$char" != " " && "$char" != "$PUDDLE_CHAR" ]]; then
            # Splash!
            ground+="${SPLASH_CHARS[$RANDOM % ${#SPLASH_CHARS[@]}]}"
            ((puddle[j]++))
        elif [[ $((puddle[j])) -gt 10 ]]; then
            # If enough water has accumulated, show a puddle
            ground+="$PUDDLE_CHAR"
            # Slowly "evaporate" or reset puddle so it's dynamic
            if (( RANDOM % 5 == 0 )); then puddle[j]=5; fi
        else
            ground+=" "
        fi
    done
    buffer[rows-1]="$ground"

    # New top line
    buffer[0]=$(generate_line)
}

# Render the current buffer with color
draw_frame() {
    printf "\033[H"
    
    # Thunder flash
    if [[ "$THUNDER_ENABLED" == "true" ]] && (( RANDOM % 80 == 0 )); then
        printf "\033[107m\033[2J"
        sleep 0.03
    fi

    for ((i=0; i<rows; i++)); do
        local line="${buffer[i]}"
        local colored_line=""
        
        # Apply color based on character type
        for ((j=0; j<cols; j++)); do
            local char="${line:$j:1}"
            case "$char" in
                " ") colored_line+=" " ;;
                "$PUDDLE_CHAR") colored_line+="${COLOR_PUDDLE}${char}${COLOR_RESET}" ;;
                "v"|"u"|"w") colored_line+="${COLOR_BRIGHT}${char}${COLOR_RESET}" ;;
                *) 
                    # Raindrops
                    if (( RANDOM % 5 == 0 )); then
                        colored_line+="${COLOR_BRIGHT}${char}${COLOR_RESET}"
                    else
                        colored_line+="${COLOR_RAIN}${char}${COLOR_RESET}"
                    fi
                    ;;
            esac
        done
        echo -e "$colored_line"
    done
    printf "%b" "${COLOR_RESET}"
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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
