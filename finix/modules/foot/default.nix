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

	".config/foot/foot.ini" = {
	  source = ./foot.ini;
          clobber = true;
	};

	};
      };
    };
  };

}
