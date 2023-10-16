#!/bin/bash
export GITHUB_URL="https://raw.githubusercontent.com/rhgdev/wshopper"

# Remove and download new files from github
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_URL"/lib/lib.sh
source /tmp/lib.sh

clear # Clear the screen before displaying the script's output
detectssh "" # Detects if SSH is running and displays warning message
checkforalma9 "" # Checks for AlmaLinux 9 and displays warning message
welcome "" # Checks for AlmaLinux 9 and displays welcome message
askformaint ""
performupgrades "" # Upgrade prompter

if askbool "Install prefab banners?"; then run_script banners; fi # Install banners

if askbool "Configure OpenSSH?"; then run_script openssh; fi  # Install openssh

if askbool "Install and Setup Fail2ban?"; then run_script fail2ban; fi  # Install fail2ban

if askbool "Install and Setup Apache?"; then run_script apache; fi  # Install Apache

if askbool "Install and Setup MariaDB?"; then run_script mariadb; fi  # Install MariaDB

if askbool "Install and Setup ASP.NET?"; then run_script aspnet; fi  # Install ASP.NET

if askbool "Install and Setup SQL Server?"; then run_script sql-server; fi  # Install SQL Server

scriptdone "" # Script is done!