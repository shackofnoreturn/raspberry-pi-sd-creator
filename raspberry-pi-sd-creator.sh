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
    echo "Didn't find an external disk" ; exit -1
fi