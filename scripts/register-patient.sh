#!/bin/bash

# Check if the script is being run by a doctor
if ! groups | grep -q Doctors; then
    echo "Only doctors can run this script"
    exit 1
fi

# Ask the doctor for patient information
echo "Enter the following information about the patient:"
read -p "First name: " firstName
read -p "Last name: " lastName
read -p "Year of birth: " yearOfBirth
read -p "Phone number: " phoneNumber
read -p "Email: " email
read -p "Registered doctors (~primaryDoctor followed by #assignedDoctors (i.e. username separated by comma (,))): " registeredDoctors

# Extract the primary and assigned doctors' usernames
primaryDoctor=$(echo "$registeredDoctors" | cut -d ',' -f 1 | cut -c 2-)
assignedDoctors=$(echo "$registeredDoctors" | sed 's/[^#]*#//g' | tr ',' ' ')

# Generate a unique patient ID based on first name, last name and year of birth
firstNameCapitalized="${firstName^}"
lastNameCapitalized="${lastName^}"
patientID="${firstNameCapitalized}${lastNameCapitalized}${yearOfBirth,,}"

# Append patient information to the file
echo "${firstNameCapitalized},${lastNameCapitalized},${yearOfBirth},${phoneNumber},${email},${registeredDoctors}" >> "/opt/WellingtonClinic/Patients/$patientID"

# Create the patient file and set the appropriate ACL for the doctors
touch "/opt/WellingtonClinic/Patients/$patientID"

if [ -n "$assignedDoctors" ] || [ -n "$primaryDoctor" ]; then
  for doctor in $primaryDoctor $assignedDoctors; do
    setfacl -m "u:$doctor:rwx" "/opt/WellingtonClinic/Patients/$patientID"
  done
else
  echo "No doctors assigned to patient $patientID"
fi


# Set the ACL perm to --- for everyone else
setfacl -m "g::---" "/opt/WellingtonClinic/Patients/$patientID"
setfacl -m "g:Doctors:---" "/opt/WellingtonClinic/Patients/$patientID"
setfacl -m "g:Nurses:---" "/opt/WellingtonClinic/Patients/$patientID"
setfacl -m "o::---" "/opt/WellingtonClinic/Patients/$patientID"


# Notify the doctor that the patient has been registered
echo "Patient registered successfully"
