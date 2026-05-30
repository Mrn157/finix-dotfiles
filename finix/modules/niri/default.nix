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

	 # Niri Setup
	 ".config/niri/config.kdl" = {
	   source = ./config.kdl;
           clobber = true;
	 };

       };
     };
   };
 };
}


