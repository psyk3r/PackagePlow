#!/bin/bash
if [ $(/etc/alpine-release) ]; then
	echo " This script does not support alpine distros"
	exit
fi
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script !"
	exit
fi

package_names=""

while IFS= read -r line; do
   package_string="{$package_names} $line"
done < package.txt

declare -A pManager;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypper
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ ${osInfo[$f]} = 'yum' ] || [${osInfo[$f]} = 'apt'] || [${osInfo[$f]} = 'zypper']]; then
        sudo $osInfo[$f] install $package_names 
    elif [ ${osInfo[$f]} = 'pacman' ]; then
	sudo pacman -S $package_names
    elif [ ${osInfo[$f]} = 'emerge' ]; then
	sudo emerge -av $package_names
    elif [ ${osInfo[$f]} = 'emerge' ]; then
	sudo emerge -av $package_name
    else
	echo "Something went wrong :/"
    fi
done
