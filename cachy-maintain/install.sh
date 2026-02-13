#!/bin/bash
# cachy-maintain installer
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "\033[1;36mInstalling cachy-maintain...\033[0m\n"

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo -e "\033[1;31mThis installer must be run as root (or via sudo).\033[0m"
    exit 1
fi

# Create directories
install -d -m 755 /usr/lib/cachy-maintain
install -d -m 755 /var/log/cachy-maintain

# Install entry point
install -m 755 "$SCRIPT_DIR/cachy-maintain" /usr/local/bin/cachy-maintain

# Install library files
install -m 644 "$SCRIPT_DIR/maintenance" /usr/lib/cachy-maintain/maintenance
install -m 644 "$SCRIPT_DIR/diagnostics" /usr/lib/cachy-maintain/diagnostics
install -m 644 "$SCRIPT_DIR/help" /usr/lib/cachy-maintain/help

echo -e "  \033[2m•\033[0m /usr/local/bin/cachy-maintain"
echo -e "  \033[2m•\033[0m /usr/lib/cachy-maintain/maintenance"
echo -e "  \033[2m•\033[0m /usr/lib/cachy-maintain/diagnostics"
echo -e "  \033[2m•\033[0m /usr/lib/cachy-maintain/help"
echo -e "  \033[2m•\033[0m /var/log/cachy-maintain/"

echo -e "\n\033[1;32mcachy-maintain installed successfully!\033[0m"
echo -e "\033[2mRun 'cachy-maintain --help' to get started.\033[0m"
