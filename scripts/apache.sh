#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/scripts/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting Apache Install.."


sudo dnf install -y -q httpd # Install Httpd
sudo systemctl enable --now httpd # Enable and Start Httpd

sudo firewall-cmd --add-service=http --permanent # Add http to firewall
sudo firewall-cmd --reload # Reload firewall

if askbool "Configure apache's UserDir (public_html)"; then
	# Configure Httpd to public html
	sudo sed -i 's%UserDir disabled%%' /etc/httpd/conf.d/userdir.conf
	sudo sed -i 's%#UserDir public_html%UserDir public_html%' /etc/httpd/conf.d/userdir.conf

	# Restart Httpd
	sudo systemctl restart httpd

	# Allow selinux to allow httpd to read home directories
	sudo setsebool -P httpd_enable_homedirs true 

	# Create public_html directory and set permission for current user
	mkdir -p ~/public_html
	chmod 711 ~

	# Create public_html directory and set permission for new users
	sudo mkdir -p /etc/skel/public_html
	sudo chmod 711 /etc/skel
fi

success "Apache Installed!"