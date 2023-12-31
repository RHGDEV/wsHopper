#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting Apache Install.."


sudo dnf install -y -q httpd # Install Httpd (Apache)
sudo systemctl enable httpd # Enable Httpd service
sudo systemctl start httpd # Start Httpd service

sudo firewall-cmd --add-service=http --permanent # Add http to firewall (permanent)
sudo firewall-cmd --reload # Reload firewall rules

if askbool "Configure apache's UserDir (public_html)"; then
	# Configure Httpd public html directories
	sudo sed -i 's%UserDir disabled%%' /etc/httpd/conf.d/userdir.conf
	sudo sed -i 's%#UserDir public_html%UserDir public_html%' /etc/httpd/conf.d/userdir.conf

	# Restart Httpd service
	sudo systemctl restart httpd

	# Allow selinux to allow httpd to read home directories
	sudo setsebool -P httpd_enable_homedirs true 

	# Create public_html directory and set permission for current user
	mkdir -p ~/public_html
	chmod 755 ~
fi

if askbool "Configure homepage redirect?"; then
	inject_txt /var/www/html/index.html /static/index.html # Simple HTML redirection content
fi

# if askbool "Configure certbot (SSL)?"; then
# 	sudo dnf install -y -q certbot python-certbot-apache
# 	sudo certbot --apache
# 	sudo certbot renew –dryrun
# fi

success "Apache Installed!"