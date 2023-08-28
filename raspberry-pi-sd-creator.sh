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
  echo "Final Pi host name is required (-n | --hostname)" >&2
  exit 1
fi

# Check for external storage devices
# TODO - Automatic disk selection
#disk_name=$(diskutil list external | grep -o '^/dev\S*')
#if [ -z "$disk_name" ]; then
#    echo "Didn't find an external disk" 
#    exit -1
#fi

# Manual drive selection
diskutil list
read -p "Select your PI's sd card (ex: /dev/disk2):" disk_name
if [ "$disk_name" = "" ]
    then
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

# Downloading image
image_path=./downloads
image_zip="$image_path/image.zip"
image_iso="$image_path/image.img"

# TODO - Check latest ver/sha online, download only if newer
# TODO - Tested on a mac wget not available right off the bat
# https://downloads.raspberrypi.org/raspbian_lite/images/?C=M;O=D
# Download image when there is none available
if [ ! -f $image_zip ]; then
    mkdir -p ./downloads
    echo "Downloading latest Raspbian lite image"
    # curl often gave "error 18 - transfer closed with outstanding read data remaining"
    wget -O $image_zip "https://downloads.raspberrypi.org/raspbian_lite_latest"
    # curl -o $image_zip "https://downloads.raspberrypi.org/raspbian_lite_brewlatest"

    if [ $? -ne 0 ]; then
        echo "Download failed" ; exit -1;
    fi
fi

# Unzipping image file
echo "Extracting ${image_zip} ISO"
unzip -p $image_zip > $image_iso

if [ $? -ne 0 ]; then
    echo "Unzipping image ${image_zip} failed" ; exit -1;
fi

# Writing image
echo "Unmounting ${disk_name} before writing image"
diskutil unmountdisk "$disk_name"

if [ $? -ne 0 ]; then
    echo "Unmounting disk ${disk_name} failed" ; exit -1;
fi

echo "Copying ${image_iso} to ${disk_name}. ctrl+t as desired for status"
sudo dd bs=1m if="$image_iso" of="$disk_name" conv=sync

if [ $? -ne 0 ]; then
  echo "Copying ${image_iso} to ${disk_name} failed" ; exit -1
fi

# Remount for further configuration
attempt=0
until [ $attempt -ge 3 ]
do
  sleep 2s
  echo "Remounting ${disk_name}"
  diskutil mountDisk "$disk_name" && break
  attempt=$[$attempt+1]
done

# Targetting SD card volume for further configuration
volume="/Volumes/boot"

# Enabling SSH
echo "Enabling ssh"
touch "$volume"/ssh

if [ $? -ne 0 ]; then
  echo "Configuring ssh failed" ; exit -1
fi