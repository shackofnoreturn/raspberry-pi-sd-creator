#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help() {
   # Display all available options
   echo "How to use this scripts options."
   echo
   echo "Syntax: raspberry-pi-sd-creator [-h|-n]"
   echo "options:"
   echo "-h | --help     Print this Help."
   echo "-n | --hostname Set a hostname."
   echo
}

############################################################
# Process the input options                                #
############################################################
# Defaults
# Set variables
hostname=""

# Get the options
while [[ $# -ge 1 ]] 
do
    option="$1"
    case $option in
        -h|--help)  # display Help
            Help
            exit
            ;;
        -n|--hostname)  # Enter a name
            hostname=$2
            shift
            ;;
        *) # Invalid option
            echo "Error: Invalid option"
            exit;;
    esac
    shift
done

############################################################
# Main program                                             #
############################################################

# Check if a hostname was entered
if [ -z "$hostname" ]; then
  echo "Final Pi host name is required (-h | --host)" >&2
  exit 1
fi

# Check for external storage devices
disk_name=$(diskutil list external | grep -o '^/dev\S*')
if [ -z "$disk_name" ]; then
    echo "Didn't find an external disk" 
    exit -1
fi

# Check if there is only a single external storage device
matches=$(echo -n "$disk_name" | grep -c '^')
if [ $matches -ne 1 ]; then
    echo "Found ${matches} external disk(s); expected 1"
    exit -1
fi

# Check if the external storage device is available
disk_free=$(df -l -h | grep "$disk_name" | egrep -oi '(\s+/Volumes/.*)' | egrep -o '(/.*)')
if [ -z "$disk_free" ]; then
    echo "Disk ${disk_name} doesn't appear mounted. Try reinserting SD card" ; exit -1
fi

# Select Volume
volume=$(echo "$disk_free" | sed -e 's/\/.*\///g')

# Display disk information
diskutil list external
echo $disk_free
echo

# Formatting disk
read -p "Format ${disk_name} (${volume}) (y/n)?" CONT
if [ "$CONT" = "n" ]
    then
        exit -1
fi

echo "Formatting ${disk_name} as FAT32"
sudo diskutil eraseDisk FAT32 PI MBRFormat "$disk_name"

if [ $? -ne 0 ]; then
    echo "Formatting disk ${disk_name} failed" ; exit -1;
fi