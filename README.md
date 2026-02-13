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

## Acknowledgements

These tools are adapted from work by the [Garuda Linux](https://garudalinux.org/) team:

- **cachy-update** is based on [garuda-update](https://gitlab.com/garuda-linux/pkgbuilds/-/tree/main/garuda-update), maintained by TNE and dr460nf1r3 (Nico).
- **cachy-maintain** is inspired by [Garuda Assistant](https://gitlab.com/garuda-linux/applications/garuda-assistant), a GUI system maintenance tool for Garuda Linux.

Thank you to the Garuda Linux team for their original work.

## License

GPL-3.0 — see the original projects above.
