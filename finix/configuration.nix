{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  finit.runlevel = 3;

  finit.services.nix-daemon = {
    environment.CURL_CA_BUNDLE = config.security.pki.caBundle;
  };

  services.nix-daemon = {
    enable = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;

  programs = {
    limine = {
      enable = true;
      settings.editor_enabled = true; # Disable on systems that need security
      force = true;
    };

    sudo.enable = true;

    bash.enable = true;

    niri.enable = true;
  };

  services = {
    polkit.enable = true;

    sysklogd.enable = true;

    dbus.enable = true;

    mdevd.enable = true;

    dhcpcd.enable = true;

    iwd.enable = true;

    seatd.enable = true;
 };

  fonts = {
	  fontconfig.enable = true;
	  enableDefaultPackages = true;
	  packages = with pkgs; [
		  nerd-fonts.jetbrains-mono
	  ];
  };

  hardware.graphics.enable = true;

  networking.hostName = "hp"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrn1 = {
    isNormalUser = true;
    description = "test user";
    extraGroups = [ "wheel" "video" config.services.seatd.group ];
    password = "$6$pJ6./et9yVNgFB7J$JO2zRx4GUzfpuZBI/mCyGB77Gn4J7ezzvt5IKm/1Bc2nSiGGepD7Y/wTx8NtBzw7HcsevGJdKKr0aeX4Vopln/";
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      neovim wget foot nemo-with-extensions nwg-look git fastfetch appimage-run unzip cargo pavucontrol btop lutris
      udisks2 udiskie ffmpeg_6-full waybar pulsemixer swaybg vulkan-tools kdePackages.kdenlive
      brightnessctl grim slurp rose-pine-cursor wl-clipboard viewnior 
      rose-pine-hyprcursor fzf gcc zsh blueman gdu protonup-ng protontricks
      mission-center xwayland-satellite wev wgcf wireguard-tools unrar cachix
      nix-init nixd python3 yad eza rofi waydroid-helper
      ninja meson plocate gnumake mpv tmux p7zip neovide steam-run libsm
      rofimoji
      tray-tui
      prismlauncher
      chawan
      nh
      hyprlauncher
      lsfg-vk-ui
      lsfg-vk
      kdiskmark
      virt-manager
      qemu_kvm
      w3m
      dualsensectl pcsx2 mgba
      reddit-tui
      openjdk17 
      emacs
      android-tools
      xdg-desktop-portal-gnome
      firefox
      wget
      git
      nixos-rebuild-ng
      iputils
      iproute2
      fish
      inputs.zen-browser.packages."${system}".default

      (pkgs.callPackage ./pkgs/yambar/yambar-pkg.nix {})
  ];



}
