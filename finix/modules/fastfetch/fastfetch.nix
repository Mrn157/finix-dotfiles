{ pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  # Place your config alongside this file, e.g. ./fastfetch.jsonc
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
}
