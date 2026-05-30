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

	# Anyrun Setup
	".config/anyrun/style.css" = { 
 	  source = ./style.css;
          clobber = true;
	};


	};
      };
    };
  };

}
