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

run_script() {
	bash <(curl -s "$GITHUB_URL/scripts/$1.sh")
}

inject_txt() {
	sudo curl -sSL -o "$1" "$GITHUB_URL/$2"
}

output() {
  echo -e "* $1"
}

info() {
  echo ""
  output "${COLOR_YELLOW}$1${COLOR_NC}"
  echo ""
}

success() {
  echo ""
  output "${COLOR_GREEN}SUCCESS${COLOR_LGREEN}: $1${COLOR_NC}"
  echo ""
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

performupgrades() {
	read -r -p "Do a full system upgrade? (y/N) " CONFIRM
	echo $CONFIRM
	if [[ "$CONFIRM" =~ [Yy] ]]; then
		sudo dnf upgrade -y
		output "System upgrade complete. Awaiting for any keypress to continue..."
		read
	else
		output "Skipping system upgrade."
	fi
}

scriptdone() {
	rm -rf /tmp/lib.sh
	echo "Hopper should be ready to go!"
	read -r -p "Restart now? (y/N) " CONFIRM
	echo $CONFIRM
	if [[ "$CONFIRM" =~ [Yy] ]]; then
		sudo reboot
	else
		output "Skipping system upgrade."
	fi
}

lib_loaded() {
  return 0
}