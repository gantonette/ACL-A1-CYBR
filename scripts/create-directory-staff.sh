#!/bin/bash

# Check if the script is being run as root or BenM
if [[ $EUID -ne 0 ]] && [[ $(whoami) != "BenM" ]]; then
   echo "This script must be run as root or BenM" 
   exit 1
fi

# Create the directory structure
mkdir /opt/WellingtonClinic
mkdir /opt/WellingtonClinic/Patients


# Create the administrator account
useradd -m -s /bin/bash BenM
echo 'BenM:admin123' | chpasswd

# Add the administrator to the sudo group
usermod -aG sudo BenM

# Create the doctor accounts
useradd -m -s /bin/bash DrMaryT
echo 'DrMaryT:asdf123' | chpasswd
useradd -m -s /bin/bash DrMandyS
echo 'DrMandyS:asdf123' | chpasswd
useradd -m -s /bin/bash DrEliM
echo 'DrEliM:asdf123' | chpasswd

# Create the nurse accounts
useradd -m -s /bin/bash LuciaB
echo 'LuciaB:asdf123' | chpasswd
useradd -m -s /bin/bash PhilM
echo 'PhilM:asdf123' | chpasswd

# Create Groups for doctors, and nurses
groupadd Doctors
groupadd Nurses

# Assign doctors to Doctor group and Ben
usermod -aG Doctors DrMaryT
usermod -aG Doctors DrMandyS
usermod -aG Doctors DrEliM
usermod -aG Doctors BenM

# Assign nurses to Nurses group
usermod -aG Nurses LuciaB
usermod -aG Nurses PhilM

