#!/bin/bash
######################################################################
# Software Manager                                                   #
######################################################################

## Add Repository
# Libre Office 5
sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-0
echo -e "Package: *\nPin: release o=LP-PPA-libreoffice-libreoffice-5-0\nPin-Priority: 701" | sudo tee /etc/apt/preferences.d/libreoffice-libreoffice-5-0.pref

# Sublime Text 3
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3

# Update Repository
sudo apt-get update

# Upgrade
DEBIAN_FRONTEND="noninteractive" sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND="noninteractive" sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

######################################################################
# Application                                                        #
######################################################################
# Fix Numlock on Login Screen
sudo apt-get install -y numlockx

# GNOME Terminal
sudo apt-get install -y gnome-terminal


# Development Tools
sudo apt-get install -y build-essential

# Install Git
sudo apt-get install -y git 

# Python
sudo apt-get install -y python3 idle3 python3-numpy python3-scipy python3-matplotlib python3-setuptools
sudo easy_install3 pip
sudo pip3 install virtualenv

# Miniconda3
sudo ./Resource/Miniconda3_x64.sh -b -p /usr/bin/miniconda3
export PATH=/usr/bin/miniconda3/bin:$PATH
sudo chown -R $USER /usr/bin/miniconda3
conda update -y conda
conda install -y numpy
conda install -y scipy
conda install -y git
conda install -y matplotlib
echo "" >> ~/.bashrc
echo "PATH=/usr/bin/miniconda3/bin:\$PATH" >> ~/.bashrc

# Ruby
sudo apt-get install -y ruby

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -f -y install

# Sublime Text
sudo apt-get install -y sublime-text-installer

# Libre Office
sudo apt-get install -y libreoffice

# Imwheel
sudo apt-get install -y imwheel

# Utility
sudo apt-get install -y zip unzip p7zip-full

# Diff Tools
sudo apt-get install -y kdiff3 meld diffuse

# Dropbox
sudo apt-get install -y nautilus-dropbox

######################################################################
# Config                                                             #
######################################################################

# Imwheel
cp ./Resource/.imwheelrc ~/.imwheelrc

# Sublime Text 3
bash Resource/sublime_config.sh

######################################################################
# Maintenance                                                        #
######################################################################

# Fix Apt-get lock
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock

# Fix Duplicate Repository
sudo rm -f /etc/apt/sources.list.d/additional-repositories.list

# Fix Missing Package
sudo apt-get install -y --fix-missing

# Remove deb file
sudo rm ./google-chrome-stable_current_amd64.deb

# Update Repository
sudo apt-get update

# Clean Apt-get
sudo apt-get -y autoremove
sudo apt-get -y clean

# Update Font Cache
sudo fc-cache -fv

# Create Swap
read -p "Create Swap file [y/n]: " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]
then
    if [[ -z $(sudo cat /etc/fstab | grep swapfile) ]];
    then
        sudo fallocate -l 4G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo "/swapfile none swap sw 0 0" | sudo tee --append /etc/fstab
    fi
fi


# Grub
sudo update-grub

######################################################################
# Prompt                                                             #
######################################################################
read -p "Complete! Do you want to restart now [ Ctrl + C to cancel ]: " -n 1 -r
sudo reboot
