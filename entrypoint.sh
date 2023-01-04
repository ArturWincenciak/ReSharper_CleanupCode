#!/bin/sh -l

echo "Hello $INPUT_WHO_TO_GREET"
echo "That is second arg: $INPUT_SOME_SECOND_ARG"
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT
