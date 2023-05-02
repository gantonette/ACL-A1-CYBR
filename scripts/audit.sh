#!/bin/bash

# Check if the script is being run by an administrator or sudoer
if [[ $(id -u) -ne 0 ]] && ! sudo -n true &> /dev/null; then
    echo "This script can only be run by an administrator or sudoer."
    exit 1
fi

echo "Username| Object| Operation| Date"
echo "-------|-------|----------|---------------------"

while true; do
    # Get the current modification time of the WellingtonClinic directory
    current_time=$(stat -c %Y /opt/WellingtonClinic)

    # Find all files and directories in the WellingtonClinic directory
    # that have a modification time greater than the current_time
    changed_files=$(find /opt/WellingtonClinic -newermt @$current_time 2>/dev/null)

    # If there are any changed files, print out information about them
    if [ -n "$changed_files" ]; then
        while read changed_file; do
            # Get the username of the user who performed the operation
            username=$(stat -c %U "$changed_file")
            
            # Get the type of operation that was performed
            if [ -d "$changed_file" ]; then
                operation="accessed"
            elif [ -f "$changed_file" ]; then
                if [[ $(stat -c %A "$changed_file") == *"w"* ]]; then
                    operation="w/write"
                elif [[ $(stat -c %A "$changed_file") == *"x"* ]]; then
                    operation="x/execute"
                else
                    operation="read"
                fi
            else
                operation="accessed"
            fi
            
            # Get the type of change that was made
            change=$(stat -c %y "$changed_file" | cut -d' ' -f1)
            
            # Print out the information about the change
            echo "$username| $changed_file| $operation| $change"
        done <<< "$changed_files"
    fi

    # Wait for 5 seconds before checking for changes again
    sleep 5
done

