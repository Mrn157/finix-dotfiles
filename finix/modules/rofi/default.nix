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

	 # Rofi Setup
	 ".config/rofi/config.rasi" = {
	   source = ./rofi/config.rasi;
           clobber = true;
	 };

       };
     };
   };
 };
}



