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
# Main program                                             #
############################################################
############################################################

# Set variables
hostname="SHACKPI"

############################################################
# Process the input options                                #
############################################################
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

echo "hello $hostname!"