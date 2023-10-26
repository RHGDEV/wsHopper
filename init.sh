#!/bin/bash
export GITHUB_URL="https://raw.githubusercontent.com/rhgdev/wshopper/master"

# Remove and download new files from github
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_URL"/lib/lib.sh
source /tmp/lib.sh

clear # Clear the screen before displaying the script's output
detectssh "" # Detects if SSH is running and displays warning message
checkforalma9 "" # Checks for AlmaLinux 9 and displays warning message
performupgrades "" # Upgrade prompter

items=(
	"Install Process"
	"Maintenance Menu"
)

while true; do
	clear
	printbanner ""
	echo ""
	echo ""
    select item in "${items[@]}" Quit
    do
        case $REPLY in
            1) clear; bash <(curl -s "$GITHUB_URL/install/init.sh"); break;;
            2) clear; bash <(curl -s "$GITHUB_URL/maint/init.sh"); break;;
            $((${#items[@]}+1))) break 0;;
            *) echo "Ooops - unknown choice $REPLY"; break;
        esac
    done
done

rm -rf /tmp/lib.sh # Remove the lib.sh file from /tmp
clear # Clear the screen before displaying the script's output