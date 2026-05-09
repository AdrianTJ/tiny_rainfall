#!/bin/bash

# Test Suite for Tiny Rainfall v2 (Ground & Puddles)

# Source the script from the parent directory
source "$(dirname "$0")/../rain_v2.sh"

# Mock tput for testing
tput() {
    if [[ "$1" == "cols" ]]; then echo 80; fi
    if [[ "$1" == "lines" ]]; then echo 24; fi
}

test_puddle_accumulation() {
    echo -n "Testing puddle accumulation... "
    update_dimensions
    cols=10
    rows=5
    # Reset puddles for clean test
    for ((j=0; j<cols; j++)); do puddles[j]=0; done
    
    # Simulate a raindrop hitting the ground at index 3
    buffer[rows-2]="   .      " # One row above the ground
    update_buffer
    
    # Check if puddle at index 3 was incremented
    # Note: update_buffer in v2 should check buffer[rows-1] after shifting
    # Wait, in rain_v1, update_buffer shifts THEN processes buffer[rows-1].
    
    if [[ "${puddles[3]}" -eq 1 ]]; then
        echo "PASS"
    else
        echo "FAIL (puddles[3]=${puddles[3]})"
        exit 1
    fi
}

echo "Running Tiny Rainfall v2 Tests..."
test_puddle_accumulation
