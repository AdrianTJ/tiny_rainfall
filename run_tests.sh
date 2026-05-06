#!/bin/bash

# Updated Test Suite for Tiny Rainfall (Step 2)

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
    # Now it's raw chars, so length should be exactly 10
    if [[ ${#line} -eq 10 ]]; then
        echo "PASS"
    else
        echo "FAIL (length=${#line}, line='$line')"
        exit 1
    fi
}

test_splash_logic() {
    echo -n "Testing splash transformation... "
    update_dimensions
    cols=5
    rows=3
    # Manually set buffer[1] to have a raindrop
    buffer[1]=". , |"
    # Call update_buffer. buffer[1] moves to buffer[2] and should become splashes.
    update_buffer
    
    local ground="${buffer[2]}"
    # Expected: . , | become splash chars (v, u, or w)
    # Check if ground contains any splash chars at indices 0, 2, 4
    if [[ "${ground:0:1}" =~ [vuw] && "${ground:2:1}" =~ [vuw] && "${ground:4:1}" =~ [vuw] ]]; then
        echo "PASS"
    else
        echo "FAIL (ground='$ground')"
        exit 1
    fi
}

# Run tests
echo "Running Tiny Rainfall Tests (Step 2)..."
test_dimensions
test_generate_line
test_splash_logic
echo "All tests passed! 🎉"
