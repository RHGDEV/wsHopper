#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# Remove and download new files from github
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_URL"/lib/lib.sh
source /tmp/lib.sh

clear # Clear the screen before displaying the script's output

if askbool "Install prefab banners?"; then run_script install banners; fi # Install banners

if askbool "Configure OpenSSH?"; then run_script install openssh; fi  # Install openssh

if askbool "Install and Setup Fail2ban?"; then run_script install fail2ban; fi  # Install fail2ban

if askbool "Install and Setup Apache?"; then run_script install apache; fi  # Install Apache

if askbool "Install and Setup MariaDB?"; then run_script install mariadb; fi  # Install MariaDB

if askbool "Install and Setup ASP.NET?"; then run_script install aspnet; fi  # Install ASP.NET

if askbool "Install and Setup SQL Server?"; then run_script install sql-server; fi  # Install SQL Server

scriptdone "" # Script is done!