#!/bin/bash

##Dependencies
#Before installing be sure to have or install next packages depending on kernel version and nvidia packages
#checking which kernel version exist in your OS

uname -a

#nvidia package, this one the number linux59 refers to kernel version and 455 to the last nvidia version drivers
sudo pacman -S linux59-nvidia-455xx
#if you have only one kernel you could use
pacman -S nvidia

#Also optimus-manager need base-devel and its installation is using "pamac" or "yay"
yay -S base-devel 
pamac install base-devel

##Installation optimus manager (Switch Graphic Card)
#Installing packages from Yaourt because optimus-manager-qt doesn't exist in pacman repositories

yaourt -S optimus-manager-qt optimus-manager

#optimus-manager service activation
systemctl start optimus-manager
systemctl enable optimus-manager

#Checking which graphic card is in used
lxinfo | grep -i vendor

#optimus manager must be rebooted to apply and start its use
#reboot


##Troubleshooting
#if you have some issues you need to fix them commenting next lines

nano /etc/ssdm.conf

#And comment following lines in [X11] section

#DisplayCommand=/usr/share/sddm/scripts/Xsetup
#DisplayStopCommand=/usr/share/sddm/scripts/Xstop

