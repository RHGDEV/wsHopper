#!/bin/bash

# VALUES
local blockquota = 500000000 # 500Gb soft block limit
local blocklimit = 500000000 # 500Gb hard block limit
local inodequota = 0 # inf soft inode limit
local inodelimit = 0 # inf hard inode limit

read -p "Enter username : " username # Get username from user
read -s -p "Enter password : " password # Get password from user
egrep "^$username" /etc/passwd >/dev/null # Check if user exists
if [ $? -eq 0 ]; then # If user exists
	echo "${username} exists!"
	exit 1
fi
read -p "Make user a sudoer? [y/N] " user_sudo # Ask if user should be sudoer
read -p "Set quotas for user? [Y/n] " user_quotas # Ask if user should have quotas

sudo useradd -m -p "$password" "$username" # Create user

if [ $user_sudo ]; then # If user should be sudoer
	sudo usermod -aG wheel $username
fi

if [ $user_quotas ]; then # If user should have quotas
	sudo setquota -u $username $blockquota $blocklimit $inodequota $inodelimit /home
fi

# Configure Httpd public html directories
sudo mkdir -p /home/$username/public_html
sudo chmod 755 /home/$username/

echo "User ${username} has been added to the system!"

# setquota user blockquota blocklimit inodequota inodelimit /home # Set quota for user