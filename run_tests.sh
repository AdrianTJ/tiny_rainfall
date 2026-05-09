#!/bin/bash

# Master Test Runner

echo "Starting all tests..."
echo "-------------------"

for test_file in tests/test_*.sh; do
    if [[ -f "$test_file" ]]; then
        bash "$test_file"
        if [ $? -ne 0 ]; then
            echo "-------------------"
            echo "❌ Some tests failed!"
            exit 1
        fi
    fi
done

echo "-------------------"
echo "✅ All tests passed! 🎉"
