{ ... }:

{
  hjem = {
    users = {
      mrn1 = {
        ".config/xdg-desktop-portal/portals.conf" = {
          source = ./portals.conf;
          clobber = true;
        };
      };
    };
  };
}
