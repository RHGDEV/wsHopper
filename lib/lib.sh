#!/bin/bash

# Colors
COLOR_YELLOW='\033[1;33m'
COLOR_LYELLOW='\033[1;93m'
COLOR_GREEN='\033[0;32m'
COLOR_LGREEN='\033[0;92m'
COLOR_RED='\033[0;31m'
COLOR_LRED='\033[0;91m'
COLOR_BLUE='\033[0;34m'
COLOR_LBLUE='\033[0;94m'
COLOR_NC='\033[0m'

# Functions
run_script() {
	bash <(curl -s "$GITHUB_URL/scripts/$1.sh")
}

inject_txt() {
	sudo curl -sSL -o "$1" "$GITHUB_URL/$2"
}

# echo functions
output() {
  echo -e "* $1"
}

info() {
  output "${COLOR_YELLOW}$1${COLOR_NC}"
}

success() {
  output "${COLOR_GREEN}SUCCESS${COLOR_LGREEN}: $1${COLOR_NC}"
}

error() {
  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_LRED}: $1${COLOR_NC}" 1>&2
  echo ""
}

warning() {
  echo ""
  output "${COLOR_YELLOW}WARNING${COLOR_LYELLOW}: $1${COLOR_NC}"
  echo ""
}

# Function to ask a question and return a T/Fvalue
askbool() {
	read -r -p "$1 (Y/n) " VAL
	if [[ "$VAL" =~ [Nn] ]]; then
		return 1
	else
		return 0
	fi
}

ask() {
  read -r -p "$1 " VAL
  return $VAL
}

# Check if the script was run via SSH and display a warning message
detectssh() {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		warning "SSH detected. This script should be ran locally to prevent any connection issues during installation."
		sleep 5
	fi
}

# Check if the script was run on AlmaLinux 9 before continuing
checkforalma9() {
	if ! [[ $(cat /etc/os-release | grep -c "almalinux:9:") -eq 1 ]]; then
		warning "This script was only tested on AlmaLinux 9. Proceed with caution."
		sleep 5
	fi
}

# Fancy welcome message :)
welcome() {
	clear
	output "Welcome to...${COLOR_LBLUE}"
	echo ""
	output "      :::    :::  ::::::::  :::::::::  :::::::::  :::::::::: :::::::::"
	output "     :+:    :+: :+:    :+: :+:    :+: :+:    :+: :+:        :+:    :+:"
	output "    +:+    +:+ +:+    +:+ +:+    +:+ +:+    +:+ +:+        +:+    +:+"
	output "   +#++:++#++ +#+    +:+ +#++:++#+  +#++:++#+  +#++:++#   +#++:++#:" 
	output "  +#+    +#+ +#+    +#+ +#+        +#+        +#+        +#+    +#+"
	output " #+#    #+# #+#    #+# #+#        #+#        #+#        #+#    #+#"
	output "###    ###  ########  ###        ###        ########## ###    ###${COLOR_NC}"
	echo ""
	echo ""
	sleep 2
}

# Ask if the installer wants to perform a full system upgrade before continuing
performupgrades() {
	if askbool "Perform a full upgrade now?" then
		info 'Performing a full system upgrade. This may take a while...'
		sudo dnf upgrade -y
		success "System upgrade complete. Awaiting for any keypress to continue..."
		read
	else
		output "Skipping system upgrade."
	fi
}

# Ask for confirmation if the installer wants to restart
scriptdone() {
	rm -rf /tmp/lib.sh # Remove the lib.sh file from /tmp
	clear # Clear the screen before displaying the script's output
	success "Hopper should be ready to go!" # Display the script is done message
	if [[ askbool "Restart now?" ]]; then # Ask if the installer wants to restart
		sudo reboot
	fi
}

# Helper function
lib_loaded() {
  return 0
}