#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/scripts/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting Banner Install.."


# Setup Banners
inject_txt /etc/issue /banners/issue.txt # Displayed before login on TTY
inject_txt /etc/issue.net /banners/issue.net.txt # Displayed before login on TTY
#inject_txt /etc/motd /banners/motd.txt # Displayed after login either on TTY or SSH


success "Banners Installed!"