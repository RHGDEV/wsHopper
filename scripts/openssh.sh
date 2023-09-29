#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/scripts/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# Start
##clear
info "Starting OpenSSH Install.."
sleep 2

# Disallow Root Login
sudo sed -i 's%#PermitRootLogin prohibit-password%PermitRootLogin no%' /etc/ssh/sshd_config

# Setup Banner File Path
sudo sed -i 's%#Banner none%Banner /etc/ssh/banner%' /etc/ssh/sshd_config

# Setup Banners
inject_txt /etc/ssh/banner /banners/sshbanner.txt

# Restart SSH
sudo systemctl restart sshd

# Finish
success "OpenSSH Installed!"
sleep 1