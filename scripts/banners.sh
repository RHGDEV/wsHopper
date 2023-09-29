#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/scripts/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# Start
##clear
info "Starting Banner Install.."
sleep 2

# Setup Banners
inject_txt /etc/issue /banners/issue.txt

# Finish
success "Banners Installed!"
sleep 1