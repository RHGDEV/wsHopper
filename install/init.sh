#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

items=(
	"Full Update and Upgrade"
	"Install banners"
	"Configure OpenSSH"
	"Install Fail2ban"
	"Install Apache"
	"Install MariaDB"
	"Install ASP.NET"
	"Install SQL Server"
)

while true; do
	clear
	printbanner ""
	echo ""
	echo "Installation Menu"
	echo ""
    select item in "${items[@]}" Quit
    do
        case $REPLY in
			1) clear; performupgrades; break;;
            2) clear; run_script install banners; break;;
            3) clear; run_script install openssh; break;;
            4) clear; run_script install fail2ban; break;;
            5) clear; run_script install apache; break;;
            6) clear; run_script install mariadb; break;;
            7) clear; run_script install aspnet; break;;
            8) clear; run_script install sql-server; break;;
            $((${#items[@]}+1))) break 0;;
            *) break;
        esac
    done
done

clear # clear after user pressed Cancel