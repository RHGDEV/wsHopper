#!/bin/bash
export GITHUB_URL="https://raw.githubusercontent.com/rhgdev/wshopper/master"

# Remove and download new files from github
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_URL"/scripts/lib.sh
source /tmp/lib.sh

welcome ""
performupgrades ""

# Install banners
run_script banners # DONE

# Install openssh
run_script openssh # DONE

# Install fail2ban
run_script fail2ban # DONE

# Install Apache
run_script apache # DONE

# Install MariaDB
#run_script mariadb # TBD

# Install ASP.NET
#run_script aspnet # TBD

# Install SQL Server
#run_script sql-server # TBD

# Done with installs
scriptdone ""