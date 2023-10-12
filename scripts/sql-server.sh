#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting MSSQL-Server Install.."


# NOTES: Install SQL Server 2022 Preview for RHEL 9
# Install SQL Server tools aswell

# Important Information ig?
# https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver15&pivots=cs1-bash

# Additional Configuration Options:
# https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf?view=sql-server-ver16#datadir

# NOTE: This is a preview version of SQL Server, not for production use.

if ! [[ $(cat /etc/selinux/config | grep -c "SELINUX=enforcing") -eq 1 ]]; then
	warning "This SQL Server preview requires SELinux to be enforcing. Please enable SELinux in enforcing and reboot before continuing."
	sleep 5
fi

sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/9/mssql-server-preview.repo # Add repo for SQL Server RHEL 9 preview
sudo yum install -y mssql-server # Install SQL Server
sudo yum install -y mssql-server-selinux # Install SQL Server selinux policy package

if askbool "Configure SQL Server now?"; then
	sudo /opt/mssql/bin/mssql-conf setup # Configure SQL Server
fi

if askbool "Install SQL Server tools?"; then
	sudo curl -o /etc/yum.repos.d/mssql-release.repo https://packages.microsoft.com/config/rhel/8/prod.repo # Add repo for SQL Server tools
	sudo dnf install -y mssql-tools unixODBC-devel # Install SQL Server tools
	echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile # Add SQL Server tools to path

	# NOTE: To access the server use 'sqlcmd -No -S localhost -U sa -P <password>'
	# -No = Disable secure connection (SSL) because we don't have a certificate
	# -S = Server address
	# -U = Username
	# -P = Password
fi

sudo firewall-cmd --add-service=mssql --permanent # Add mssql:1433 tcp to firewall (permanent)
sudo firewall-cmd --reload # Reload firewall rules


success "MSSQL-Server Installed!"