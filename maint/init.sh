#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# TODO: Write maintenance scripts for this
items=(
	"Create User"
	"Unban IP"
	#"Delete User"
	#"Change User Password"
	#"Change User Quota"
	#"Change User Sudo Status"
	"Read secure log"
	"Read Fail2Ban log"
)

while true; do
	clear
	printbanner "Maintenance Menu"
    select item in "${items[@]}" Back
    do
        case $REPLY in
            1) clear; run_script maint accountcreate; break;;
            2) clear; run_script maint f2bunban; break;;
			3) clear; sudo cat /var/log/secure | less +G; break;;
            4) clear; sudo cat /var/log/fail2ban.log | less +G; break;; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            #4) echo "not yet";; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            #5) echo "not yet";; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            $((${#items[@]}+1))) break 0;;
            *) break;
        esac
    done
done