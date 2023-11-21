#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting MSSQL-Server Install.."


# Important Information ig?
# https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver15&pivots=cs1-bash

# Additional Configuration Options:
# https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf?view=sql-server-ver16#datadir


# Add repo for SQL Server RHEL 9 preview
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/9/mssql-server-2022.repo
sudo yum install -y mssql-server # Install SQL Server

if askbool "Configure SQL Server now?"; then
	sudo /opt/mssql/bin/mssql-conf setup # Configure SQL Server
fi

if askbool "Install SQL Server tools?"; then
	curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo # Add repo for SQL Server tools
	sudo yum install -y mssql-tools18 unixODBC-devel # Install SQL Server tools

	echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile # Add SQL Server tools to path
	echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc # Add SQL Server tools to path
	source ~/.bashrc # Reload bashrc
	# NOTE: To access the server use 'sqlcmd -No -S localhost -U sa -P <password>'
	# -No = Disable secure connection (SSL) because we don't have a certificate
	# -S = Server address
	# -U = Username
	# -P = Password
fi

sudo firewall-cmd --add-service=mssql --permanent # Add mssql:1433 tcp to firewall (permanent)
sudo firewall-cmd --reload # Reload firewall rules


success "MSSQL-Server Installed!"