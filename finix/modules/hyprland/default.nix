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

	# Hyprland Setup
   	  ".config/hypr/hyprland.conf" = {
 	    source = ./hyprland.conf;
            clobber = true;
  	 };
       };
     };
   };
 };

}
