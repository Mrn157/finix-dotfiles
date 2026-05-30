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

       	 # MangoWC Setup
	 ".config/mango/config.conf" = {
	   source = ./config.conf;
           clobber = true;
	 };

       };
     };
   };
 };
}

