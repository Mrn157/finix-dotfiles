{ inputs, ... }:

{
  hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
    ];
    clobberByDefault = true;
    users = {
      mrn1 = {
        files = {
          ".config/nvim/init.lua" = {
            source = ./nvim/init.lua;
            clobber = true;
          };
          ".config/nvim/lua" = {
            source = ./nvim/lua;
            clobber = true;
          };
        };
      };
    };
  };


}

