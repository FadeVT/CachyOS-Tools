# CachyOS Tools

A collection of system administration tools for CachyOS.

## Tools

### cachy-update
System update tool modeled on garuda-update. Handles full system updates with mirror refresh, keyring management, and automatic conflict resolution.

### cachy-maintain
System maintenance & diagnostics CLI tool. Covers orphan package removal, package cache cleanup, pacnew handling, log management, and system diagnostics.

## Installation

Each tool has its own `install.sh`. Run with root privileges:

```bash
# Install cachy-update
sudo bash cachy-update/install.sh

# Install cachy-maintain
sudo bash cachy-maintain/install.sh
```

## Usage

```bash
cachy-update --help
cachy-maintain --help
```
