#!/bin/bash
# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_URL"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi
info "Starting ASP.Net Install.."


# NOTES: Install ASP.Net for RHEL 9
sudo dnf install -y -q dotnet-runtime-6.0 dotnet-sdk-6.0 dotnet-targeting-pack-6.0 dotnet-templates-6.0 dotnet-hostfxr-6.0

success "ASP.Net Installed!"