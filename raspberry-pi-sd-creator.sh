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
# Process the input options                                #
############################################################
# Get the options
while getopts ":h" option 
do
    case $option in
        h) # display Help
            echo "HELP"
            Help
            exit
            ;;
        \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
    esac
    shift
done

echo "Hello World"