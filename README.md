# NixOS basic config

This repository stores NixOS and Home Manager configs organized per host.

## Layout

- `hosts/<hostname>/etc/`: raw copy of that host's `/etc/nixos` (flake and classic `configuration.nix` live here)
- `hosts/<hostname>/home-manager/`: Home Manager flake and modules for that user/host

## Usage (flakes)

- NixOS rebuild (from repo root):
  - Switch: `sudo nixos-rebuild switch --flake hosts/<hostname>/etc#nixos -L`
  - Test: `sudo nixos-rebuild test --flake hosts/<hostname>/etc#nixos -L`

- Home Manager (from repo root):
  - Switch: `home-manager switch --flake hosts/<hostname>/home-manager#sid@nixos`

Adjust `<hostname>` and flake attributes as needed. The provided examples assume the host is named `nixos` and the user is `sid`.

## Sync from a running system

To refresh configs from the current machine into this repo (idempotent):

```bash
HOST="$(hostnamectl --static 2>/dev/null || hostname)"
DEST="$(pwd)/hosts/${HOST}/etc"
mkdir -p "$DEST"
sudo rsync -aHAX --delete /etc/nixos/ "$DEST/"
sudo chown -R "$(id -u)":"$(id -g)" "$(pwd)/hosts/${HOST}"
```

If you keep standalone Home Manager in `~/.config/home-manager`, you can optionally sync it as:

```bash
HOST="$(hostnamectl --static 2>/dev/null || hostname)"
HM_DEST="$(pwd)/hosts/${HOST}/home-manager"
mkdir -p "$HM_DEST"
rsync -a --delete --exclude='.git/' "$HOME/.config/home-manager/" "$HM_DEST/"
```

## Notes

- Sensitive material (tokens, secrets) should not be committed. Use SOPS/age or pass for secrets when needed.
- Disk UUIDs and hostnames in `hardware-configuration.nix` are machine-specific and expected in per-host trees.


