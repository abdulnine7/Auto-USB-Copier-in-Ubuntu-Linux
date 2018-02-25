#!/bin/bash

##################################################################################################
#
#
# Automatic copy files from USB to computer on connect!
#
#
# Author: Abdul Noushad Sheikh ('abdulnine7' on GitHub)
#
#
##################################################################################################

setup=true

die() {
  echo -e "\033[1;31m$@\033[0m"
  exit 1
}

message(){
	export DISPLAY=:0
	notify-send "$@" -t 500
}

#Usb Device connected message
message "Usb Device Connected"

#Setup for running
if $setup; then

	if [[ $(/usr/bin/id -u) -ne 0 ]]; then
		die "For Setup run as root..."
	fi
	
	sudo touch /etc/udev/rules.d/pendrive.rules
	sudo echo "ACTION==\"add\",KERNEL==\"sd*\", SUBSYSTEMS==\"usb\", ATTRS{idProduct}==\"*\", ATTRS{idVendor}==\"*\", RUN+=\"/home/qwerty/pendrive.sh %k\"" > /etc/udev/rules.d/pendrive.rules
	sudo /etc/init.d/udev restart
	sudo udevadm control --reload-rules
	die "Setup successful"
fi

#Getting mountpoint of the usb drives

usb_dirs=(`lsblk -l | grep -e part -e disk | grep sd[bc] | awk '{ printf $7 "\n"; }'`)

if [ ${#usb_dirs[@]} -eq 0 ]; then
	die "\nNo USB Device connected...\n"
fi

#Copiying the data from pendrive

for((i=0;i<${#usb_dirs[@]};i++))
do
	echo -e "\033[1;33mCopying from... ${usb_dirs[$i]}"
  mkdir ~/copied_data 2> /dev/null
	cp -r ${usb_dirs[$i]} ~/copied_data
done

#Copiying done
message $(date +"%A %d-%B-%Y");
exit 0
