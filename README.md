# Notes: 
A test of FinixOS and test how much i can make it more daily driveable

## Screenshot (As of May 29 2026)

![Screenshot](https://i.postimg.cc/VkqhrZGq/Screenshot-from-2026-05-29-23-10-08.png)

Plans:

- [x] Working Config
- [x] Audio
- [x] Niri
- [x] Declarative `.config`
- [x] Declarative ZSH
- [x] Zen Browser
- [x] Access to Stable + Unstable packages 
- [ ] Auto Login without a DM
- [ ] Declarative nvim
- [ ] CachyOS Kernel
- [x] Cursor Theming
- [x] GTK Theming
- [x] Icon Theming
- [x] Lutris Gaming
- [x] Steam Gaming
- [ ] Waydroid


# My current install method (minimal ISO):


Finix can use NixOS minimal ISO.

Go root so you don't have to keep using the sudo command

```bash
sudo su
```

Formatting
```bash
cfdisk # Do what you want, resize, create, partitions
```
```bash
lsblk
```
```bash
mkfs.fat -F 32 /dev/<boot-partition>
```
```bash
mkfs.ext4 /dev/<root-partition>
```
```bash
mkswap /dev/<swap-partition>
```

Mounting:
```bash
mount /dev/<root-partition> /mnt
```
```bash
mkdir -p /mnt/boot
```
```bash
mount /dev/<boot-partition> /mnt/boot
```
```bash
swapon /dev/swap-partition>
```
Get neovim
```bash
nix-shell -p neovim
```
Useful neovim commands
```bash
:split | terminal
:split ./path/to/other.nix
:bd
```
Clone repo to anywhere, i usually put it at `/mnt/etc`
```bash
git clone https://github.com/Mrn157/finix-dotfiles.git
```
Generate a nix config
```bash
sudo nixos-generate-config --root /mnt
```
Now here. I use neovim and open two neovims, using `:split`. The generated and this ones hardware-configuration.nix. Make sure to use `/dev/sdX` instead of `/dev/disk/by-uuid`
```bash
nvim hardware-configuration.nix
:split ./generated-hardware-configuration.nix
```
Then
```bash
nixos-install --root /mnt --flake .#hp
```
I then give my user a password
```bash
nixos-enter # chroot equivalent of Nix
passwd mrn1
exit
```

You can now exit the installation ISO and boot
