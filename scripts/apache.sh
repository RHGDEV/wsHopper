#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  # shellcheck source=lib/lib.sh
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/scripts/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# Start
##clear
info "Starting Apache Install.."
sleep 2

sudo dnf install -y -q httpd # Install Httpd
sudo systemctl enable httpd # Enable Httpd
sudo systemctl start httpd # Start Httpd

sudo firewall-cmd --add-service=http --permanent # Add http to firewall
sudo firewall-cmd --reload # Reload firewall

# Configure Httpd to public html
sudo sed -i 's%UserDir disabled%%' /etc/httpd/conf.d/userdir.conf
sudo sed -i 's%#UserDir public_html%UserDir public_html%' /etc/httpd/conf.d/userdir.conf

# Restart Httpd
sudo systemctl restart httpd

sudo setsebool -P httpd_enable_homedirs true # Allow selinux to allow httpd to read home directories

mkdir -p ~/public_html # Make public_html for current user
chmod 711 ~ # Set permissions for public_html

sudo mkdir -p /etc/skel/public_html # Make public_html for new users
sudo chmod 711 /etc/skel # Set permissions

# Finish
success "Apache Installed!"
sleep 1