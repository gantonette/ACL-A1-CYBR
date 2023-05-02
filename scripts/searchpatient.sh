#!/bin/bash

# Check if the script is being run by a doctor
if ! groups | grep -q Doctors; then
    echo "Only doctors can run this script"
    exit 1
fi

# Get the current doctor's username
doctor=$(whoami)

# Define the patient folder
patientFolder="/opt/WellingtonClinic/Patients"

# Loop through patient files and check if the current doctor has access
echo "Doctor: $doctor"
echo "Patients:"
for file in "$patientFolder"/*; do
    if getfacl -p "$file" 2>/dev/null | grep -E "^user:$doctor:rwx" >/dev/null; then
	patient_name=$(cat "$file" | awk -F ',' '{print $1 " " $2}' | head -n 1)
        echo "$patient_name"
    fi
done
