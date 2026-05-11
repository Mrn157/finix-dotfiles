# Minimal Finix
This is my minimal configuration for finix. It installs absolutely nothing but the things needed to work on and expand a finix configuration.

I am not promising you a perfect system that will work exactly how you want with services you want. I am promising you a system that boots and is self sufficient enough to get it where you want eventually.

# Notes

Make sure that the NixOS installation boots using UEFI, legacy booting was causing issues with `limine` not being detected. If you have a fix please let me know.

I try not to inject any opinions into this configuration. The only choice I have made is between `mdevd` and `udev`. I chose `mdevd` simply because that is what the other members of the finix community suggested and use.

Because of issues with `mdevd`, drives must be identified by their ID, eg `/dev/sda1`. This causes multidrive systems to be basically unusable. If you want to try this out, just replace `programs.mdevd.enable` with `programs.udev.enable` and add the `udev` module.

Some users get errors from `efibootmgr` after running `nixos-install`. If the error code is 8, this can be ignored. It's caused by non-existant boot options trying to be added by `efibootmgr`, it fails to add them and returns an error, but existing boot entries are added without issue.

# Requirements

- Nix Flakes
- Internet

# Installing

[Installation Instructions](./docs/INSTALL.md)

# Helpful links

[Finix](https://github.com/finix-community/finix)

[Finix Options Wiki](https://finix-community.github.io/finix/options.html)

[aanderse Config](https://github.com/aanderse/finix-config)

[Finit](https://github.com/finit-project/finit)
