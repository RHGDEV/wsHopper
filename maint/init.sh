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
	"Delete User"
	"Change User Password"
	"Change User Quota"
	"Change User Sudo Status"
)

while true; do
	clear
	printbanner ""
	echo ""
	echo "Maintenance Menu"
	echo ""
    select item in "${items[@]}" Quit
    do
        case $REPLY in
            1) clear; bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh"); break;;
            2) echo "not yet";; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            3) echo "not yet";; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            4) echo "not yet";; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            5) echo "not yet";; #bash <(curl -s "$GITHUB_URL/maint/scripts/accountcreate.sh");;
            $((${#items[@]}+1))) break 0;;
            *) echo "Ooops - unknown choice $REPLY"; break;
        esac
    done
done

clear # clear after user pressed Cancel