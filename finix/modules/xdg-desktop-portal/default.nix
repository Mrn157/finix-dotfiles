{ ... }:

{
  hjem = {
    users = {
      mrn1 = {
        files = {
          ".config/xdg-desktop-portal/portals.conf" = {
            source = ./portals.conf;
            clobber = true;
          };
        };
      };
    };
  };
}
