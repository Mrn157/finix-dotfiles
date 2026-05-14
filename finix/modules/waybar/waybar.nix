{ pkgs, ... }:

{
  # Place your config alongside this file, e.g. ./fastfetch.jsonc
  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/style.css".source = ./style.css;
}
