# Notes: 

My personal finix dotfiles

Useful links:

[Finix Repo](https://github.com/finix-community/finix) \
[Finix Options](https://finix-community.github.io/finix/options.html) \
[Finix Minimal Config and Installation Guide](https://codeberg.org/vitrial/finix-config) \
[Creator's Config](https://github.com/aanderse/finix-config) \
[Finix Config Example](https://github.com/deathbymanatee/finix-config)

---

## Screenshot

![Screenshot](https://i.postimg.cc/5ydc5Sn2/img-2026-05-30-14-07-00.png)

Plans:

- [x] Working Config
- [x] Audio
- [x] Niri
- [x] Declarative `.config`
- [x] Declarative ZSH
- [x] Zen Browser
- [x] Access to Stable + Unstable packages 
- [x] Auto Login without a DM
- [x] Declarative nvim
- [x] CachyOS Kernel
- [x] Cursor Theming
- [x] GTK Theming
- [x] Icon Theming
- [x] Lutris Gaming
- [x] Steam Gaming
- [x] Waydroid

# Stuff you want to know

- My bluetooth mouse, which is the Logitech M196, connects but cursor doesn't move

My Solution: Set 
```nix
boot.initrd.kernelModules = [ "uhid" ];
```

- When I unplug and plug my USB peripherals such as wired mouse and wired keyboard it connects but clicking, typing, etc doesn't work.

My Solution: Set 
```nix
mdevd.nlgroups = 4;
```

- Fixes the blink after boot (which messes up niri and just makes a blank screen if run before the blink)

My Solution: Set
```nix
boot.initrd.kernelModules = [ "amdgpu"];
```

---

# Commands to remember for me:

## Waydroid
```bash
sudo waydroid container start
waydroid show-full-ui
```

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
