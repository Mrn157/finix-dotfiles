{ config, pkgs, inputs, lib, ... }:


# Audio Setup

let
  pipewire' =
    (pkgs.pipewire.override (
      lib.optionalAttrs config.services.mdevd.enable {
        enableSystemd = false;
        udev = pkgs.libudev-zero;
      }
    )).overrideAttrs
      (o: {
        # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/2398#note_2967898
        patches = o.patches or [ ] ++ lib.optionals config.services.mdevd.enable [ ./pkgs/pipewire/pipewire.patch ];
      });

  wireplumber' = pkgs.wireplumber.override (
    lib.optionalAttrs config.services.mdevd.enable {
      pipewire = pipewire';
    }
  );
in

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
	"audio"
	"input"
	"seat"
	"pipewire"
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

    bash = {
    	enable = true;
    };

    niri.enable = true;

    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
        {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
        ];
        # theme = spicePkgs.themes.text;
        # colorScheme = "RosePine";
      };

      xwayland-satellite.enable = true;

  };

  services = {
      # Audio setup
      mdevd.hotplugRules = lib.mkMerge [
    (lib.mkAfter ''
      SUBSYSTEM=input;.* root:input 660
      SUBSYSTEM=sound;.* root:audio 660
    '')

    ''
      grsec       root:root 660
      kmem        root:root 640
      mem         root:root 640
      port        root:root 640
      console     root:tty 600 @chmod 600 $MDEV
      card[0-9]   root:video 660 =dri/

      # alsa sound devices and audio stuff
      pcm.*       root:audio 0660 =snd/
      control.*   root:audio 0660 =snd/
      midi.*      root:audio 0660 =snd/
      seq         root:audio 0660 =snd/
      timer       root:audio 0660 =snd/
      card[0-9]   root:video 660 =dri/

      adsp        root:audio 0660 >sound/
      audio       root:audio 0660 >sound/
      dsp         root:audio 0660 >sound/
      mixer       root:audio 0660 >sound/
      sequencer.* root:audio 0660 >sound/

      event[0-9]+ root:input 660 =input/
      mice        root:input 660 =input/
      mouse[0-9]+ root:input 660 =input/

      rfkill      root:${config.services.seatd.group} 660
    ''
  ];

    rtkit.enable = true;
    rtkit.extraGroups = lib.optionals (config.services.elogind.enable == false) [
 	   config.services.seatd.group
    ];

    polkit.enable = true;

    sysklogd.enable = true;

    dbus.enable = true;

    mdevd.enable = true;

    dhcpcd.enable = true;

    iwd.enable = true;

    seatd.enable = true;

    bluetooth.enable = true;
 };

 hardware.firmware = with pkgs; [
    linux-firmware
    sof-firmware
    wireless-regdb
  ];

 xdg.autostart.enable = true;
  # Enable icons
  xdg.icons.enable = true;
  xdg.mime.enable = true;
  xdg.portal.enable = true;

  xdg.portal.portals = [
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-gtk
  ];

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
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      neovim wget foot nemo-with-extensions nwg-look git fastfetch appimage-run unzip cargo pavucontrol btop 
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

      # Audio Setup
      pipewire'
      wireplumber'

      bluetui
      shadow
      openssh
      inputs.zen-browser.packages."${system}".default

      (pkgs.callPackage ./pkgs/yambar/yambar-pkg.nix {})

  ];





}
