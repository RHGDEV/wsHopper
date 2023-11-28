#!/bin/bash

read -p "Enter username : " username # Get username from user
read -s -p "Enter password : " password # Get password from user
egrep "^$username" /etc/passwd >/dev/null # Check if user exists
if [ $? -eq 0 ]; then # If user exists
	echo "${username} exists!"
	exit 1
fi
echo "" # New line
read -p "Set quotas for user? [Y/n] " user_quotas # Ask if user should have quotas
sudo useradd -m -p "$password" "$username" # Create user with password and home directory

# 500Gb soft/hard block limit
# inf soft/hard inode limit
if [[ "$user_sudo" =~ [Nn] ]]; then # If user should have quotas
	sudo setquota -u $username 500000000 500000000 0 0 /home
fi

# Configure Httpd public html directories
sudo mkdir -p /home/$username/public_html
sudo chmod 755 /home/$username/
sudo chown $username:$username /home/$username/public_html

echo "User ${username} has been added to the system!"
sleep 2