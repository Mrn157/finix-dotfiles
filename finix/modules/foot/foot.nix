{ lib, config, ... }:

with lib;
let cfg = config.modules.foot;

in {
  options.modules.foot = { enable = mkEnableOption "foot"; };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono NF:size=12";
          "font-bold" = "JetBrainsMono NF:style=Bold:size=12";
          shell = "/run/current-system/sw/bin/zsh";
          pad = "20x20";
        };

        colors-dark = {
          foreground = "cdd6f4"; # Text
          background = "141423"; # Base

          regular0 = "45475a"; # Surface 1
          regular1 = "f38ba8"; # red
          regular2 = "a6e3a1"; # green
          regular3 = "f9e2af"; # yellow
          regular4 = "89b4fa"; # blue
          regular5 = "f5c2e7"; # pink
          regular6 = "94e2d5"; # teal
          regular7 = "bac2de"; # Subtext 1

          bright0 = "585b70"; # Surface 2
          bright1 = "f38ba8"; # red
          bright2 = "a6e3a1"; # green
          bright3 = "f9e2af"; # yellow
          bright4 = "89b4fa"; # blue
          bright5 = "f5c2e7"; # pink
          bright6 = "94e2d5"; # teal
          bright7 = "a6adc8"; # Subtext 0
        };

        scrollback = {
          "indicator-position" = "fixed";
          "indicator-format" = "percentage";
        };

        "key-bindings" = {
          "clipboard-copy" = "Control+c XF86Copy";
          "clipboard-paste" = "Control+v XF86Paste";
        };
      };
    };
  };
}
