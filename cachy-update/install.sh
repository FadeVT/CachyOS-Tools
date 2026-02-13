#!/bin/bash
# install.sh — Install cachy-update to the system
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing cachy-update..."

# Create directories
sudo mkdir -p /usr/lib/cachy-update
sudo mkdir -p /etc/cachy-update/hotfixes.d
sudo mkdir -p /var/log/cachy-update

# Install main entry point
sudo install -Dm755 "$SCRIPT_DIR/cachy-update" /usr/local/bin/cachy-update

# Install library scripts
sudo install -Dm755 "$SCRIPT_DIR/main-update" /usr/lib/cachy-update/main-update
sudo install -Dm755 "$SCRIPT_DIR/auto-pacman" /usr/lib/cachy-update/auto-pacman
sudo install -Dm755 "$SCRIPT_DIR/help" /usr/lib/cachy-update/help

# Create default config if it doesn't exist
if [ ! -f /etc/cachy-update/config ]; then
    sudo tee /etc/cachy-update/config > /dev/null << 'CONF'
# cachy-update configuration
# Uncomment and set to 1 to enable options permanently

# SKIP_MIRRORLIST=1     # Don't refresh mirrors
# UPDATE_AUR=1          # Always update AUR packages
# NO_SPACE_CHECK=1      # Skip btrfs disk space check
# PACMAN_NOCONFIRM=1    # Auto-confirm (dangerous)
# CHECK_NEWS=1          # Always check Arch news
CONF
fi

# Create shell aliases
echo ""
echo "Installation complete!"
echo ""
echo "Files installed:"
echo "  /usr/local/bin/cachy-update        (main command)"
echo "  /usr/lib/cachy-update/main-update  (core update logic)"
echo "  /usr/lib/cachy-update/auto-pacman  (Expect wrapper for pacman)"
echo "  /usr/lib/cachy-update/help         (help text)"
echo "  /etc/cachy-update/config           (configuration)"
echo "  /etc/cachy-update/hotfixes.d/      (hotfix scripts directory)"
echo ""
echo "Optional: Add a shell alias for convenience:"
echo '  echo '\''alias update="cachy-update"'\'' >> ~/.bashrc'
echo '  echo '\''alias update="cachy-update"'\'' >> ~/.config/fish/config.fish  # for fish'
echo ""
echo "Dependencies:"
echo "  Required: bash, pacman, sudo"
echo "  Recommended: expect (for auto-pacman), rate-mirrors or cachyos-rate-mirrors"
echo "  Optional: informant (for Arch news checking), paru or yay (for AUR)"
echo ""
echo "Usage: cachy-update --help"
