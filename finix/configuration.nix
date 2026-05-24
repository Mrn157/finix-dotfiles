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
      ./modules/zsh/zsh.nix
    ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Make booting silent except for errors
  boot.kernelParams = [
    "loglevel=3"
  ];

  # Fixes the blink after boot (which messes up niri and just makes a blank screen if run before the blink)
  boot.kernelModules = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];



  finit.runlevel = 3;

  finit.services.nix-daemon = {
    environment.CURL_CA_BUNDLE = config.security.pki.caBundle;
  };

  providers.privileges.rules = lib.optionals config.services.mdevd.enable [
    {
      command = "/run/current-system/sw/bin/poweroff";
      groups = [ config.services.seatd.group ];
      requirePassword = false;
    }
    {
      command = "/run/current-system/sw/bin/reboot";
      groups = [ config.services.seatd.group ];
      requirePassword = false;
    }
    /*
    {
      command = "/run/current-system/sw/bin/brightnessctl";
      groups = [ config.services.seatd.group ];
      requirePassword = false;
    }
    */
  ];

  # Audio priority
  environment.etc."security/limits.conf".text = ''
    @audio   -   rtprio     95
    @audio   -   nice       -19
    @audio   -   memlock    4194304
  '';

  # Zsh boot error fix
  environment.etc."set-environment".text = ''
  '';

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

  programs = {
    limine = {
      enable = true;
      settings.editor_enabled = true; # Disable on systems that need security
      settings.timeout = 1;
      settings.quiet = true;
      force = true;
    };

    sudo.enable = true;

    bash = {
    	enable = true;
    };

    niri.enable = true;

    mangowc.enable = true;

    hyprland.enable = true;

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

      plymouth = {
       enable = true;
      };

      brightnessctl.enable = true;

  };

  boot = {
    loader.efi.canTouchEfiVariables = true;
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

    # For bluetooth
    bluetooth = {
     enable = true;
     # Downgrade to make ps5 controller work
     package = (pkgs.callPackage ./pkgs/bluez/bluez.nix {});
    };

    # For time syncing
    chrony.enable = true;

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
  hardware.graphics.enable32Bit = true;

  networking.hostName = "hp"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrn1 = {
    isNormalUser = true;
    description = "Me";
    extraGroups = [
	"wheel"
	"video"
	"audio"
	"input"
	"seat"
	"pipewire"
        config.services.seatd.group ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
  (with pkgs; [
      neovim wget foot nemo-with-extensions nwg-look git fastfetch appimage-run unzip cargo pavucontrol btop 
      udisks udiskie ffmpeg_6-full waybar pulsemixer swaybg vulkan-tools kdePackages.kdenlive
      grim slurp rose-pine-cursor wl-clipboard viewnior tray-tui lsfg-vk-ui lsfg-vk
      rose-pine-hyprcursor fzf gcc gdu protonup-ng protontricks kdiskmark virt-manager qemu_kvm
      mission-center xwayland-satellite wev wgcf wireguard-tools unrar cachix git nixos-rebuild-ng iputils iproute2
      nix-init nixd python3 yad eza rofi waydroid-helper steam prismlauncher w3m wget bluetui shadow openssh openresolv
      ninja meson plocate gnumake mpv tmux p7zip neovide steam-run libsm rofimoji chawan nh hyprlauncher
      dualsensectl pcsx2 mgba reddit-tui openjdk17 emacs android-tools xdg-desktop-portal-gnome impala
      # Audio Setup
      pipewire'
      wireplumber'
      inputs.helium.packages.${system}.default 
      inputs.zen-browser.packages."${system}".default

      (pkgs.callPackage ./pkgs/yambar/yambar-pkg.nix {})
      # (pkgs.openldap.overrideAttrs (oldAttrs: {
      # doCheck = !pkgs.stdenv.hostPlatform.isi686;
      # }))

  ])

  ++

  (with inputs.pkgs-stable; [
    lutris-free
  ]);

  # For configuring user config files

  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
    ];
    clobberByDefault = true;
    users = {
      mrn1 = {
        enable = true;

        files = {

	# Bash Setup
        ".bash_profile" = {
	  source = ./modules/terminal/.bash_profile;
	};

        # Wallpaper Setup
        "Pictures/wallpaper.jpg" = {
	  source = ./modules/wallpaper.jpg;
	};

	# Niri Setup
	".config/niri/config.kdl" = {
	  source = ./modules/niri/config.kdl;
          clobber = true;
	};

	# MangoWC Setup
	".config/mango/config.conf" = {
	  source = ./modules/mango/config.conf;
          clobber = true;
	};


	# Foot Setup
	".config/foot/foot.ini" = {
	  source = ./modules/foot/foot.ini;
          clobber = true;
	};

	# Hyprland Setup
	".config/hypr/hyprland.conf" = {
	  source = ./modules/hyprland/hyprland.conf;
          clobber = true;
	};

	# Rofi Setup
	".config/rofi/config.rasi" = {
	  source = ./modules/rofi/rofi/config.rasi;
          clobber = true;
	};

	# Dwl Setup
	".config/dwl/config.def.h" = {
	  source = ./modules/dwl/config.def.h;
          clobber = true;
	};

	# Anyrun Setup
	".config/anyrun/style.css" = { 
 	  source = ./modules/anyrun/style.css;
          clobber = true;
	};

	# Yambar Setup
	".config/yambar" = { 
	  source = ./modules/yambar;
          clobber = true;
	};

	# Waybar Setup
	".config/waybar" = { 
	  source = ./modules/waybar;
          clobber = true;
	};

	# Fastfetch Setup
	".config/fastfetch/config.jsonc" = {
	  source = ./modules/fastfetch/config.jsonc;
          clobber = true;
	};


	};
      };
    };
  };

}
