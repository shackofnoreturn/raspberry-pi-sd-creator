#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help() {
   # Display all available options
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-g|h|v|V]"
   echo "options:"
   echo "g     Print the GPL license notification."
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo "V     Print software version and exit."
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
        -h)  # display Help
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