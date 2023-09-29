#!/bin/bash
export GITHUB_URL="https://raw.githubusercontent.com/rhgdev/wshopper/master"

# Remove and download new files from github
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_URL"/scripts/lib.sh
source /tmp/lib.sh

welcome "" # Checks for AlmaLinux 9 and displays welcome message
performupgrades "" # Upgrade prompter


run_script banners # Install banners

run_script openssh # Install openssh

run_script fail2ban # Install fail2ban

run_script apache # Install Apache

#run_script mariadb # Install MariaDB

#run_script aspnet # Install ASP.NET

#run_script sql-server # Install MariaDB

scriptdone "" # Script is done!