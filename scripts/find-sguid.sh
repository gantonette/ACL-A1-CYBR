#!/bin/bash

# Get the home directory of the specified user
user_home=$(getent passwd "$1" | cut -d: -f6)

# Check if the user home directory exists
if [[ ! -d "$user_home" ]]; then
    echo "Error: User home directory does not exist"
    exit 1
fi

# Print header
printf "%-20s\t%-8s\t%-10s\t%-10s\t%-s\n" "File or directory" "Type" "Permission" "Permission/Octal" "Note (for 'suspicious' files with SGUID)"

# Recursively search the user's home directory for files and directories
while IFS= read -r -d '' file; do
    # Get the file permissions
    permissions=$(stat -c "%A" "$file")

    # Get the octal representation of the file permissions
    octal=$(printf '%04o' "$(stat -c "%a" "$file")")

    # Check if the file has set SUID or SGID bits
    if [[ $(stat -c "%A" "$file") =~ [sS] ]]; then
        permissions="$permissions *suspicious"
    fi

    # Print the file path, permissions, and octal representation
    printf "%s\t%s\t%s\n" "$file" "$permissions" "$octal"
done < <(find "$user_home" -print0)
#!/bin/bash

# Get the home directory of the specified user
user_home=$(getent passwd "$1" | cut -d: -f6)

# Check if the user home directory exists
if [[ ! -d "$user_home" ]]; then
    echo "Error: User home directory does not exist"
    exit 1
fi

# Recursively search the user's home directory for files and directories
while IFS= read -r -d '' file; do
    # Get the file permissions
    permissions=$(stat -c "%A" "$file")

    # Get the octal representation of the file permissions
    octal=$(printf '%04o' "$(stat -c "%a" "$file")")

    # Check if the file has set SUID or SGID bits
    if [[ $(stat -c "%A" "$file") =~ [sS] ]]; then
        permissions="$permissions *suspicious"
    fi

    # Print the file path, permissions, and octal representation
    printf "%s\t%s\t%s\n" "$file" "$permissions" "$octal"
done < <(find "$user_home" -print0)
#!/bin/bash

# Get the home directory of the specified user
user_home=$(getent passwd "$1" | cut -d: -f6)

# Check if the user home directory exists
if [[ ! -d "$user_home" ]]; then
    echo "Error: User home directory does not exist"
    exit 1
fi

# Recursively search the user's home directory for files and directories
while IFS= read -r -d '' file; do
    # Get the file permissions
    permissions=$(stat -c "%A" "$file")

    # Get the octal representation of the file permissions
    octal=$(printf '%04o' "$(stat -c "%a" "$file")")

    # Check if the file has set SUID or SGID bits
    if [[ $(stat -c "%A" "$file") =~ [sS] ]]; then
        permissions="$permissions *suspicious"
    fi

    # Print the file path, permissions, and octal representation
    printf "%s\t%s\t%s\n" "$file" "$permissions" "$octal"
done < <(find "$user_home" -print0)
#!/bin/bash

# Get the home directory of the specified user
user_home=$(getent passwd "$1" | cut -d: -f6)

# Check if the user home directory exists
if [[ ! -d "$user_home" ]]; then
    echo "Error: User home directory does not exist"
    exit 1
fi

# Recursively search the user's home directory for files and directories
while IFS= read -r -d '' file; do
    # Get the file permissions
    permissions=$(stat -c "%A" "$file")

    # Get the octal representation of the file permissions
    octal=$(printf '%04o' "$(stat -c "%a" "$file")")

    # Check if the file has set SUID or SGID bits
    if [[ $(stat -c "%A" "$file") =~ [sS] ]]; then
        permissions="$permissions *suspicious"
    fi

    # Print the file path, permissions, and octal representation
    printf "%s\t%s\t%s\n" "$file" "$permissions" "$octal"
done < <(find "$user_home" -print0)
