#!/bin/bash

# Check that the script is being run as root, sudo or admin
if [ "$(id -u)" != "0" ] && ! groups | grep -q '\bsudo\b'; then
    echo "This script must be run as root or by a user in the sudo/admin group."
    exit 1
fi

# Get the username as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi
username="$1"

# Get the user information
user_info=$(getent passwd "$username")

# Extract the fields from the user information
user_id=$(echo "$user_info" | cut -d: -f3)
group_id=$(echo "$user_info" | cut -d: -f4)
home_dir=$(echo "$user_info" | cut -d: -f6)

# Get the user's groups
groups=$(id -nG "$username" | tr ' ' ',')

# Check if the user has a shadow file
if [ -e "/etc/shadow" ]; then
    shadow="Yes"
else
    shadow="No"
fi

# Get the hashing algorithm used for passwords
hashing_algorithm=$(sudo grep -oP '^.*:\K[^:]*' /etc/shadow)

# Get the date of the last password change
last_password_change=$(chage -l "$username" | grep "Last password change" | cut -d: -f2)

# Display the user information
echo "Username: $username"
echo "Groups: $groups"
echo "UserID: $user_id"
echo "Group(s) ID: $group_id"
echo "Home Directory: $home_dir"
echo "Shadow file?: $shadow"
echo "Hashing Algorithm Used? $hashing_algorithm"
echo "Date of last password change: $last_password_change"
