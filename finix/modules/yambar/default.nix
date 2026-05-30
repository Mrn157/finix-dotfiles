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

	 # Yambar Setup
  	 ".config/yambar" = { 
	  source = ../yambar;
          clobber = true;
	 };

       };
     };
   };
 };
}





