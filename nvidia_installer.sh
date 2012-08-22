#!/bin/bash
# Modified by UbuntuXtreme.com
# Author: drpaneas@ubuntuxtreme.com
# Date: 22/08/2012
# License Artistic License 2.0 
# Remove Open Source Drivers
echo "Please save any work and close any open apps you may have (exept this one) cause after the completion, your system WILL REBOOT! "
echo ""
echo ""
echo ""
sleep 5
echo "Removing old modules..."
sleep 2
sudo rmmod -f vga16fb
sudo rmmod -f nouveau
sudo rmmod -f rivafb
sudo rmmod -f nvidiafb
sudo modprobe -b vga16fb
sudo modprobe -b nouveau
sudo modprobe -b rivafb
sudo modprobe -b nvidiafb
sudo apt-get --purge remove xserver-xorg-video-nouveau
sudo update-initramfs -u


# Remove nVIDIA Proprietary (old)
echo "Removing nVIDIA Proprietary (old)..."
sleep 2
sudo apt-get purge nvidia* -y
# Remove all nvidia* packages in the system
echo "Removing all nvidia* packages in the system..."
sleep 2
sudo dpkg -l | grep nvidia | awk '{ print $2 }' | xargs sudo apt-get purge
		 
# Remove all the nvidia kernel objects currently installed
echo "Removing all the nvidia kernel objects currently installed..."
sleep 2
export kernel_version=`uname -r`
sudo rm -f `find /lib/modules/$kernel_version -iname nvidia.ko`

# Add X-Swat PPA
echo "Adding X-Swat PPA..."
sleep 2
sudo add-apt-repository ppa:ubuntu-x-swat/x-updates 

# Update
sudo apt-get update

# Upgrade
sudo apt-get upgrade -y

# Install (if not installed)
sudo apt-get install xdiagnose xserver-xorg-video-intel

# Install NVIDIA unified
sudo apt-get install nvidia-current -y
clear
# Reboot your PC
echo "Your system will now reboot... in 5 seconds..."
sleep 1
echo "5..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
echo "Boooom :)"
sudo shutdown -r 0

