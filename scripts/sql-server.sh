#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/scripts/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

# Start
##clear
info "Starting MSSQL-Server Install.."
sleep 2

# NOTES: Install SQL Server 2022 Preview for RHEL 9
# Install SQL Server tools aswell

# Finish
success "MSSQL-Server Installed!"
sleep 1