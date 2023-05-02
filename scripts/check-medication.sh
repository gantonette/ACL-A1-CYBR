#!/bin/bash

# Check if the script is being run by a nurse
if ! groups | grep -q Nurses; then
    echo "Only nurses can run this script"
    exit 1
fi

# Ask for patient information
read -p "Enter patient's first name: " firstName
read -p "Enter patient's last name: " lastName
read -p "Enter patient's year of birth: " yearOfBirth

# Generate patient ID based on first name, last name and year of birth
firstNameCapitalized="${firstName^}"
lastNameCapitalized="${lastName^}"
patientID="${firstNameCapitalized}${lastNameCapitalized}${yearOfBirth,,}"

# Check if the patient file exists
if [ ! -f "/opt/WellingtonClinic/Patients/$patientID" ]; then
    echo "Patient file not found"
    exit 1
fi

# Extract patient information
patientInfo=$(grep "^$firstName,$lastName,$yearOfBirth" "/opt/WellingtonClinic/Patients/$patientID")
firstName=$(echo $patientInfo | cut -d ',' -f 1)
lastName=$(echo $patientInfo | cut -d ',' -f 2)
yearOfBirth=$(echo $patientInfo | cut -d ',' -f 3)
phoneNumber=$(echo $patientInfo | cut -d ',' -f 4)
email=$(echo $patientInfo | cut -d ',' -f 5)
primaryDoctor=$(echo $patientInfo | cut -d ',' -f 6 | cut -d '~' -f 2)
assignedDoctors=$(echo $patientInfo | cut -d ',' -f 7 | sed 's/#/ /g')

# Extract visit information
visitInfo=$(echo "$patientInfo" | tail -n +2)
echo "Patient: $firstName $lastName (born $yearOfBirth)"
echo "Primary Doctor: $primaryDoctor"
echo "Assigned Doctors: $assignedDoctors"
echo

# Loop through all visits
while read -r visit; do
    attendedDoctor=$(echo $visit | cut -d ',' -f 1)
    dateOfVisit=$(echo $visit | cut -d ',' -f 2)
    healthIssue=$(echo $visit | cut -d ',' -f 3)
    medication=$(echo $visit | cut -d ',' -f 4)
    dosage=$(echo $visit | cut -d ',' -f 5)
    
    # Print out visit information
    echo "Date of Visit: $dateOfVisit"
    echo "Attended Doctor: $attendedDoctor"
    echo "Medication: $medication"
    echo "Dosage: $dosage"
    echo
done <<< "$visitInfo"
