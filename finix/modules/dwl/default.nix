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

	# Dwl Setup
	".config/dwl/config.def.h" = {
	  source = ./config.def.h;
          clobber = true;
	};

	};
      };
    };
  };

}
