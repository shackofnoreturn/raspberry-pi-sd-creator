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
hostname="SHACKPI"

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
############################################################

echo "hello $hostname!"

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

# Display disk information
diskutil list external
echo $disk_free
echo