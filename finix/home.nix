{ pkgs, inputs, ... }:

{
  imports = [
    ./modules/foot/foot.nix
    ./modules/fastfetch/fastfetch.nix
    ./modules/hyprland/hyprland.nix
    ./modules/rofi/rofi.nix
    ./modules/waybar/waybar.nix
    ./modules/nvchad/nvchad.nix
    ./modules/niri/niri.nix
    ./modules/anyrun/anyrun.nix
    ./modules/zsh/zsh.nix
    ./modules/yambar/yambar.nix
    inputs.zen-browser.homeModules.beta
  ];

  ################
  ### PACKAGES ###
  ################

  # Install plugin packages and extras
  home.packages = with pkgs; [
      hyprpicker
      fzf
      legcord
  ];

  ################
  ### PROGRAMS ###
  ################
  programs.zen-browser.enable = true;

  programs.btop = {
    enable = true;
  };

  programs.btop.settings = {
    color_theme = "horizon";
    theme_background = false;
  };

   # Example: you can add more programs here
  programs.git.enable = true;
  programs.bat.enable = true;
  programs.bash = {
    enable = true;
    bashrcExtra = /* bash */ ''
    if [[ "$(tty)" == "/dev/tty1" ]] && [[ -z "$DISPLAY" ]]; then
      exec niri-session -l > /dev/null 2>&1  # niri-session -l fixes issue with gtk and blinking cursor issue when logging in
      fi
    '';
  };

  programs.anyrun = {
    enable = true;
    extraCss = builtins.readFile ./modules/anyrun/style.css;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
      ];
    };
  };


  ######################
  ### MISCELLANEOUS ###
  ######################
  # Remember this!!! a .keep will is generated in order to make Pictures/Screenshots which is needed for grim/screenshots
  home.file."Pictures/Screenshots/.keep".text = "something";
  home.file."Pictures/wallpaper.jpg".source = ./modules/wallpaper.jpg;


  # Basic user info
  home.username = "mrn1";
  home.homeDirectory = "/home/mrn1";
  home.stateVersion = "25.05"; # match your system version


  dconf = {
    enable = true;
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
          exec = "foot";
      };
      # Fixes no dark mode on some programs
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
            # exec-arg = ""; # argument
      };
    };
  };

  modules.foot.enable = true;

  xdg.userDirs.setSessionVariables = true;
  # Creates empty folders/directories
  xdg.userDirs.createDirectories = true;
  # Fixes no icons for folders like "Downloads", "Pictures", ...
  xdg.userDirs.enable = true;

  

  #############
  ### THEME ###
  #############

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    # size = 20;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
  };

  gtk = {
    enable = true;
    theme = {
     name = "Rosepine-Purple-Dark";
     package = (pkgs.callPackage ./pkgs/rosepine-gtk-theme/rosepine-gtk-theme.nix {});
    };


    iconTheme = {
      name = "Dracula";
      package = (pkgs.callPackage ./pkgs/dracula-circle-icon-theme/dracula-circle-icon-theme.nix {});
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    cursorTheme = {
      name = "BreezeX-RoséPine";
      package = pkgs.rose-pine-cursor;
      size = 21;
    };
  };
}

