{ ... }:

{

  # Place your config alongside this file, e.g. ./fastfetch.jsonc
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  xdg.configFile."niri/float.py".source = ./float.py;

  # Disable XDG autostarted apps
  # Quickly check if theres any unwanted programs XDG is running
  /* ls /run/current-system/sw/etc/xdg/autostart/ 
     ls ~/.config/autostart/
  */
  xdg.configFile."autostart/blueman.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
  xdg.configFile."autostart/gnome-keyring-pkcs11.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
  xdg.configFile."autostart/gnome-keyring-secrets.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
