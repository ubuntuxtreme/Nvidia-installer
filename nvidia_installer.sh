#!/bin/bash
# Modified by UbuntuXtreme.com
# Author: drpaneas@ubuntuxtreme.com
# Date: 22/08/2012
# License Artistic License 2.0 
# Remove Open Source Drivers

intro()
{	clear
	echo -e "\e[1;32m ______________________________________________________"
	echo "|                                                      |"
	echo "|       uXeye GPU Drivers Installer ver 1.0            |"
	echo "|                 UbuntuXtreme.com                     |"
	echo "|                                                      |"
	echo "| Welcome to UbuntuXtreme's automated installer script |"
	echo "| for your graphics card drivers. Sit back and relax.  |"
	echo "|                                                      |"  
	echo "|______________________________________________________|"
	echo -e "\e[0m"
}

# Routine for Latest NVIDIA Proprietary Drivers
nVIDIA_Prop_2()
{

    # Remove PPA X-Swat (in case of stable drivers)
    intro
    echo -e "\e[1;32mRemoving PPA X-Swat in case of stable drivers\e[0m"
    sleep 1
    echo "\n" | sudo apt-get -qq install ppa-purge; 
    echo "\n" | sudo ppa-purge ppa:ubuntu-x-swat/x-updates -y;
    sudo rm /etc/apt/sources.list.d/ubuntu-x-swat-x-updates-*

    # Remove Open Source Drivers
    intro
    echo -e "\e[1;32mRemoving Open Source Drivers (if any)\e[0m"
    sleep 1
    sudo rmmod -f vga16fb;
    sudo rmmod -f nouveau;
    sudo rmmod -f rivafb;
    sudo rmmod -f nvidiafb;
    sudo modprobe -b vga16fb;
    sudo modprobe -b nouveau;
    sudo modprobe -b rivafb;
    sudo modprobe -b nvidiafb;
    sudo apt-get --purge remove xserver-xorg-video-nouveau;
    sudo update-initramfs -u;

    # Remove nvidia proprietary
    intro
    echo -e "\e[1;32mRemove previous nVidia drivers\e[0m"
    sleep 1
    sudo apt-get -qq purge nvidia*;

    # Remove all nvidia* packages in the system
    intro
    echo -e "\e[1;32mRemove previous nvidia packages\e[0m"  
    sleep 1 
    sudo dpkg -l | grep nvidia | awk '{ print $2 }' | xargs sudo apt-get -qq purge;
			 
    # Remove all the nvidia kernel objects currently installed
    intro
    echo -e "\e[1;32mRemove nVIDIA kernel modules\e[0m"
    sleep 1
    export kernel_version=`uname -r`;
    sudo rm -f `find /lib/modules/$kernel_version -iname nvidia.ko`;

    # Install Xorg-Edgers
    intro
    echo -e "\e[1;32mAdd Xorg-Edgers PPA\e[0m"
    sleep 1
    echo "\n" | sudo add-apt-repository ppa:xorg-edgers/ppa;
    sudo apt-get -qq update;

    # update xdiagnose and xserver-xorg-video-intel
    intro
    echo -e "\e[1;32mUpdate xserver-xorg\e[0m"
    sleep 1
    sudo apt-get -qq upgrade;

    # or install them
    sudo apt-get -qq install xdiagnose xserver-xorg-video-intel;

    # Install the latest stable nVIDIA unified driver
    intro
    echo -e "\e[1;32mInstalling drivers\e[0m"
    sleep 1
    sudo apt-get -qq install nvidia-current;

    sudo apt-get -qq update;
    sudo apt-get -qq upgrade;

    # Reboot your machine
    intro
    echo -e "\e[1;32mRebooting your PC in 5 sec...\e[0m"
    sleep 5
    sudo shutdown -r 0;
}


nVIDIA_Prop_3()
{

	# Remove PPA Xorg-Edgers (in case of beta drivers)
	intro
	echo "\n" | sudo apt-get install ppa-purge -y -qq;

	echo -e "\e[1;32mRemoving PPA Xorg-Edgers (if any) in case of beta drivers\e[0m"
	echo "\n" | sudo ppa-purge ppa:xorg-edgers/ppa -y;
	sudo rm /etc/apt/sources.list.d/xorg-edgers-ppa-precise.list
	sudo rm /etc/apt/sources.list.d/xorg-edgers-ppa-precise.list.save
	
	# Remove PPA X-Swat (in case of stable drivers)
	intro
	echo -e "\e[1;32mRemoving PPA X-Swat in case of stable drivers\e[0m"
	echo "\n" | sudo ppa-purge ppa:ubuntu-x-swat/x-updates -y;
	sudo rm /etc/apt/sources.list.d/ubuntu-x-swat-x-updates-*

	# Remove Open Source Drivers
	intro
	echo -e "\e[1;32mRemoving Open Source Drivers (if any)\e[0m"
	sudo rmmod -f vga16fb;
	sudo rmmod -f nouveau;
	sudo rmmod -f rivafb;
	sudo rmmod -f nvidiafb;
	sudo modprobe -b vga16fb;
	sudo modprobe -b nouveau;
	sudo modprobe -b rivafb;
	sudo modprobe -b nvidiafb;
	sudo apt-get --purge remove xserver-xorg-video-nouveau;
	sudo update-initramfs -u;

	# Remove nvidia proprietary
	intro
	echo -e "\e[1;32mRemove previous nVidia drivers\e[0m"
	echo "\n" | sudo apt-get purge nvidia* -qq;

	# Remove all nvidia* packages in the system
	intro
	echo -e "\e[1;32mRemove previous nvidia packages\e[0m"
	sudo dpkg -l | grep nvidia | awk '{ print $2 }' | xargs sudo apt-get -y purge;

	# Remove all the nvidia kernel objects currently installed
	intro
	echo -e "\e[1;32mRemove nVIDIA kernel modules\e[0m"
	export kernel_version=`uname -r`;
	sudo rm -f `find /lib/modules/$kernel_version -iname nvidia.ko`;

	# Install the latest open source drivers
	intro
	echo -e "\e[1;32mFail-safe drivers\e[0m"
	echo "\n" | sudo apt-get update
	echo "\n" | sudo apt-get upgrade

	# Reboot your machine
	intro
	echo -e "\e[1;32mReboot your PC\e[0m"
	sudo shutdown -r 0;

}




# Checking if the user has run the script with "sudo" or not
if [ $EUID -ne 0 ] ; then
    clear
    echo ""
    echo -e "\e[1;32mCritical Error\e[0m"
    echo "Tip: run the script using sudo command... " 1>&2
    echo ""
    sleep 2
    exit 1
fi

intro

# Start
sleep 2

# Information
echo -e " Let me identify your GPU..."		

_GPU=`sudo apt-get install mesa-utils -y;`
gpudriver=`sudo lshw -C display | grep "driver" | awk -F "=" '{print $2}' | awk -F " " '{print $1}' | uniq;`
GPU_vendor=`glxinfo | grep "OpenGL vendor string:" | awk -F ": " '{print $2}'`
GPU_model=`glxinfo | grep "OpenGL renderer string:" | awk -F ": " '{print $2}'`
GPU_model_2=`echo $GPU_model | awk -F "/" '{print $1}'`
GPU_drivers=`glxinfo | grep "OpenGL version string" | awk -F ": " '{print $2}'`
GPU_rendering=`glxinfo | grep "direct rendering:" | awk -F ": " '{print $2}'`

echo -e "\e[1;32mVideo Card:\e[0m"
echo -e "\tVendor: \033[1m$GPU_vendor\033[0m"
echo -e "\tGPU:    \033[1m$GPU_model_2\033[0m"
echo -e "\tDriver in use:  \033[1m$gpudriver\033[0m"
echo -e "\tDriver version: \033[1m$GPU_drivers\033[0m"
echo -e "\tDirect Rendering: \033[1m$GPU_rendering\033[0m"

sleep 1

# In case of NVIDIA Proprietary
if [ "$gpudriver" == "nvidia" ]; then
    echo -e "\nSo you're using \e[1;32mnVIDIA Proprietary Drivers\e[0m"
    sleep 3
    intro
    echo -e "What do you want me to do ?"
    echo -e "\e[1;32m1.\e[0m Update to the latest \033[1mProprietary\033[0m drivers"
    echo -e "\e[1;32m2.\e[0m Remove Proprietary drivers and install Nouveau \033[1m(Open Source Drivers)\033[0m"
    echo -e "\e[1;32m3.\e[0m Quit"
    echo -e "Answer: (1, 2, or 3)"
    read n
    case $n in
            1) nVIDIA_Prop_2;;
	    2) nVIDIA_Prop_3;;
	    3) exit;;
	    *) echo "invalid option. Exit...";;
    esac
fi

# In case of NVIDIA Open Source Nouveau
if [ "$gpudriver" == "nouveau" ]; then
    echo -e "\nSo you're using \e[1;32mNouveau Open Source drivers\e[0m"
    sleep 3
    clear
    echo -e "\e[1;32m ______________________________________________________"
    echo "|                                                      |"
    echo "|       uXeye GPU Drivers Installer ver 1.0            |"
    echo "|                 UbuntuXtreme.com                     |"
    echo "|                                                      |"
    echo "| Welcome to UbuntuXtreme's automated installer script |"
    echo "| for your graphics card drivers. Sit back and relax.  |"
    echo "|                                                      |"  
    echo "|______________________________________________________|"
    echo -e "\e[0m"
    echo -e "What do you want me to do ?"
    echo -e "\e[1;32m1.\e[0m Remove OpenSource drivers and install latest \033[1mProprietary\033[0m drivers"
    echo -e "\e[1;32m2.\e[0m Quit"
    echo -e "Answer: (1 or 2)"
    read n
    case $n in
            1) nVIDIA_Prop_2;;
	    2) exit;;
	    *) echo "invalid option. Exit...";;
    esac
fi

# In case of NVIDIA Open Source Nouveau
if [ "$gpudriver" == "" ]; then
    echo -e "\nSo you have fucked up your drivers..."
    sleep 3
    clear
    echo -e "\e[1;32m ______________________________________________________"
    echo "|                                                      |"
    echo "|       uXeye GPU Drivers Installer ver 1.0            |"
    echo "|                 UbuntuXtreme.com                     |"
    echo "|                                                      |"
    echo "| Welcome to UbuntuXtreme's automated installer script |"
    echo "| for your graphics card drivers. Sit back and relax.  |"
    echo "|                                                      |"  
    echo "|______________________________________________________|"
    echo -e "\e[0m"
    echo -e "What do you want me to do ?"
    echo -e "\e[1;32m1.\e[0m Fix my drivers"
    echo -e "\e[1;32m2.\e[0m Quit"
    echo -e "Answer: (1 or 2)"
    read n
    case $n in
            1) nVIDIA_Prop_2;;
	    2) exit;;
	    *) echo "invalid option. Exit...";;
    esac
fi