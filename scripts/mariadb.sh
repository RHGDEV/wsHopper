#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting MariaDB Install.."


sudo dnf install -y -q  mariadb-server mariadb # Install MariaDB

sudo systemctl enable mariadb # Enable MariaDB
sudo systemctl start mariadb # Start MariaDB

sudo firewall-cmd --add-service=mysql --permanent # Add mysql to firewall
sudo firewall-cmd --reload # Reload firewall

if askbool "Secure MariaDB now? (runs mysql_secure_installation)"; then
	sudo mysql_secure_installation
fi
# sudo mysql -u root -p



success "MariaDB Installed!"