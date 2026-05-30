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

	# Waybar Setup
	 ".config/waybar" = { 
	   source = ../waybar;
           clobber = true;
	 };

       };
     };
   };
 };
}




