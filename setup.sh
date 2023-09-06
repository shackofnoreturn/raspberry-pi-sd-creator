#!/bin/bash
echo "Running post installation script."

# Network configuration
echo "Current hostname: "
sudo hostname

echo "Changing hostname to ${host}"
sudo sed -i 's/raspberrypi/${host}/g' /etc/hostname
sudo sed -i 's/raspberrypi/${host}/g' /etc/hosts

# Security
echo "Changing pi user password:"
passwd pi

# Reboot after all changes above complete
echo "Restarting to apply changes in 10 seconds." 
echo "After that,  run ssh pi@${host}.local"
sleep 10
/sbin/shutdown -r now