#!/bin/bash
echo "Running post installation script."

# Network configuration
sudo hostname ${host}

# Reboot after all changes above complete
echo "Restarting to apply changes." 
echo "After that,  run ssh pi@${host}.local"
/sbin/shutdown -r now