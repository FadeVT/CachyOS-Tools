# cachy-update

A comprehensive CLI update tool for CachyOS, inspired by [garuda-update](https://wiki.garudalinux.org/en/garuda-update) from Garuda Linux.

Instead of running raw `pacman -Syu` and hoping for the best, `cachy-update` wraps the entire update process with safety checks, automatic conflict resolution, mirror refresh, and retry logic — all in a single command.

## What it does

1. **Self-updates** — ensures you're running the latest version before proceeding
2. **Refreshes mirrors** — runs `cachyos-rate-mirrors` for CachyOS repos, then `rate-mirrors` for Arch mirrors
3. **Updates keyrings** — `archlinux-keyring`, `cachyos-keyring`, `chaotic-keyring` (if installed)
4. **Runs hotfixes** — executes scripts from `/etc/cachy-update/hotfixes.d/` for known conflict resolution
5. **System update via auto-pacman** — an Expect wrapper around pacman that:
   - Automatically resolves known package conflicts (e.g. `jack2` → `pipewire-jack`)
   - Performs btrfs-aware disk space checking (accounts for CoW/snapshot overhead)
   - Auto-retries on corrupt downloads (switches to CDN77 mirror)
   - Auto-retries on download failures (disables parallel downloads)
   - Auto-overwrites harmless python `__pycache__` conflicts
6. **AUR update** (optional) — delegates to `paru` or `yay`
7. **Post-update housekeeping** — updates file databases, fish completions
8. **Reports** — orphaned packages, `.pacnew` files, kernel updates needing reboot

## Safety features

- **Snapshot boot detection** — refuses to update if booted into a btrfs snapshot (changes would be lost)
- **SIGINT handling** — Ctrl+C works properly even when rate-mirrors/reflector are running
- **Privilege management** — elevates to root once via sudo, drops back to user for AUR operations
- **Persistent logging** — all output logged to `/var/log/cachy-update/cachy-update.log` with ANSI codes stripped
- **Automatic retry** — parses pacman error logs and retries with appropriate fixes

## Installation

```bash
git clone <this-repo>
cd cachy-update
chmod +x install.sh
./install.sh
```

### Dependencies

| Package | Status | Purpose |
|---------|--------|---------|
| `bash`, `pacman`, `sudo` | **Required** | Core functionality |
| `expect` | **Recommended** | Powers auto-pacman (conflict resolution, space check) |
| `cachyos-rate-mirrors` | **Recommended** | CachyOS mirror ranking |
| `rate-mirrors` | **Recommended** | Arch mirror ranking |
| `informant` | Optional | Arch Linux news checking |
| `paru` or `yay` | Optional | AUR package updates |

## Usage

```bash
# Standard update
cachy-update

# Update system + AUR packages
cachy-update -a

# Skip mirror refresh (faster)
cachy-update --skip-mirrorlist

# Check Arch news before updating
cachy-update -n

# Non-interactive
cachy-update --noconfirm

# Pass extra args to pacman
cachy-update -- --overwrite '*'
```

## Configuration

Persistent settings in `/etc/cachy-update/config`:

```bash
# UPDATE_AUR=1          # Always update AUR packages
# SKIP_MIRRORLIST=1     # Don't refresh mirrors
# CHECK_NEWS=1          # Always check Arch news
```

## Hotfixes

Drop executable `.sh` scripts into `/etc/cachy-update/hotfixes.d/` for package conflict resolution or pre-update migrations. These run before the main `pacman -Syu`.

Example hotfix (`/etc/cachy-update/hotfixes.d/001-remove-deprecated.sh`):
```bash
#!/bin/bash
if pacman -Qi some-old-package &>/dev/null; then
    echo "Removing deprecated package: some-old-package"
    SNAP_PAC_SKIP=y pacman -Rdd --noconfirm some-old-package 2>/dev/null || true
fi
```

## Architecture

```
cachy-update                  # Entry point: privilege escalation, self-update
  └─ main-update              # Core pipeline: mirrors, keyrings, hotfixes, update, AUR
       └─ auto-pacman          # Expect script: wraps pacman for interactive handling
  └─ help                      # Help text
```

This mirrors the `garuda-update` architecture where the entry point is a thin bootstrapper and the real logic lives in sourced scripts under `/usr/lib/`.

## Conflict resolution table

The `auto-pacman` Expect script contains a table of known package replacements (adapted from garuda-update, minus Garuda-specific entries). When pacman asks about a conflict that matches an entry in this table, it's automatically accepted. Unknown conflicts prompt the user interactively (or are skipped in `--noconfirm` mode).

To add new entries, edit the `auto_replace_conflicts` array in `/usr/lib/cachy-update/auto-pacman`.

## Credits

Heavily inspired by [garuda-update](https://gitlab.com/garuda-linux/pkgbuilds/-/tree/main/garuda-update) by the Garuda Linux team. The auto-pacman Expect wrapper concept and retry logic are adapted from their implementation (GPL-3.0).

## License

GPL-3.0 (matching garuda-update's license)
