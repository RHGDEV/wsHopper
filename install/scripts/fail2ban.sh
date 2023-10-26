#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting Fail2ban Install.."


sudo dnf install -y -q epel-release # Add EPEL repo for Fail2ban
sudo dnf install -y -q fail2ban fail2ban-firewalld # Install Fail2ban and firewalld support for Fail2ban

sudo systemctl enable fail2ban # Enable Fail2ban on boot
sudo systemctl start fail2ban # Start Fail2ban service

# Setup firewalld for Fail2ban
sudo mv /etc/fail2ban/jail.d/00-firewalld.conf /etc/fail2ban/jail.d/00-firewalld.local

# Setup sshd jail for Fail2ban
sudo tee -a /etc/fail2ban/jail.local > /dev/null <<EOT
[sshd]
enabled = true
bantime = 1d
maxretry = 3
findtime = 5m
EOT

sudo systemctl restart fail2ban # Restart Fail2ban service to apply changes


success "Fail2ban Installed!"