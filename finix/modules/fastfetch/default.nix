{ inputs, ... }:

{

hjem = {
    extraModules = [
      inputs.hjem-rum.hjemModules.default
    ];
    clobberByDefault = true;
    users = {
      mrn1 = {
        enable = true;

        files = {

	# Fastfetch Setup
	".config/fastfetch/config.jsonc" = {
	  source = ./config.jsonc;
          clobber = true;
	};

	};
      };
    };
  };

}
