{ pkgs, ... }:

{
  # Place your config alongside this file, e.g. ./fastfetch.jsonc
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
}
