#!/bin/bash

# Test Suite for Tiny Rainfall v1 (Foundation)

# Source the script from the parent directory
source "$(dirname "$0")/../rain_v1.sh"

# Mock tput for testing
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
        echo "FAIL"
        exit 1
    fi
}

test_splash_logic() {
    echo -n "Testing splash transformation... "
    update_dimensions
    cols=5
    rows=3
    buffer[1]=". , |"
    update_buffer
    
    local ground="${buffer[2]}"
    # Check if rain characters were converted to the splash character 'v'
    if [[ "${ground:0:1}" == "v" && "${ground:2:1}" == "v" && "${ground:4:1}" == "v" ]]; then
        echo "PASS"
    else
        echo "FAIL (ground='$ground')"
        exit 1
    fi
}

echo "Running Tiny Rainfall v1 Tests..."
test_dimensions
test_splash_logic
