#!/bin/bash

# Set the directory where the files are located
directory="./"

# Get the current time in seconds
current_time=$(date +%s)

# Loop through all files in the directory
for file in "$directory"/*; do
    # Get the modification time of the file in seconds
    file_time=$(stat -c %Y "$file")
    # Calculate the difference between the current time and the
    # modification time of the file, in days
    time_diff=$(( (current_time - file_time) / 86400 ))
    # Extract the file name and extension
    file_name=$(basename "$file")
    # If the difference is more than 14 days and the file has the .txt extension,
    # delete the file
    if [ "$time_diff" -gt 14 ] && [ "${file_name##*.}" == "txt" ]; then
        rm "$file"
    fi
done


#!/bin/bash

# Set the directory where the files are located
directory="./"

# Get the current time in seconds
current_time=$(date +%s)

# Loop through all files in the directory
for file in "$directory"/*; do
    # Get the modification time of the file in seconds
    file_time=$(stat -c %Y "$file")
    # Calculate the difference between the current time and the
    # modification time of the file, in days
    time_diff=$(( (current_time - file_time) / 86400 ))
    # If the difference is more than 14 days, delete the file
    if [ "$time_diff" -gt 14 ]; then
        rm "$file"
    fi
done
