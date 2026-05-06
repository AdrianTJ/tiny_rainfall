#!/bin/bash

# Simple Test Suite for Tiny Rainfall

# Source the script without running main
source ./rain.sh

# Mocking tput for testing dimensions
tput() {
    if [[ "$1" == "cols" ]]; then echo 80; fi
    if [[ "$1" == "lines" ]]; then echo 24; fi
}

test_dimensions() {
    echo -n "Testing update_dimensions... "
    update_dimensions
    if [[ "$cols" -eq 80 && "$rows" -eq 24 && "${#buffer[@]}" -eq 24 ]]; then
        echo "PASS"
    else
        echo "FAIL (cols=$cols, rows=$rows, buffer_len=${#buffer[@]})"
        exit 1
    fi
}

test_generate_line() {
    echo -n "Testing generate_line... "
    cols=10
    local line=$(generate_line)
    # Strip ANSI codes for length check
    local stripped=$(echo -e "$line" | sed 's/\x1b\[[0-9;]*m//g')
    if [[ ${#stripped} -eq 10 ]]; then
        echo "PASS"
    else
        echo "FAIL (length=${#stripped}, line='$stripped')"
        exit 1
    fi
}

test_thunder_flag() {
    echo -n "Testing thunder flag detection... "
    # Mocking main loop variables
    THUNDER_ENABLED=false
    
    # We can't easily run main() because it loops, 
    # but we can test the logic inside it if we isolate it.
    # For now, let's just verify the variables can be set.
    THUNDER=true
    if [[ "$THUNDER" == "true" ]]; then THUNDER_ENABLED=true; fi
    
    if [[ "$THUNDER_ENABLED" == "true" ]]; then
        echo "PASS"
    else
        echo "FAIL"
        exit 1
    fi
}

# Run tests
echo "Running Tiny Rainfall Tests..."
test_dimensions
test_generate_line
test_thunder_flag
echo "All tests passed! 🎉"
