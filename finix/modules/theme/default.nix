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

 	# GTK 3.0
	".config/gtk-3.0" = {
	  source = ./gtk-3.0;
	};

	# GTK 4.0
	".config/gtk-4.0" = {
	  source = ./gtk-4.0;
	};

	# GTKRC-2.0
	".gtkrc-2.0" = {
	  source = ./.gtkrc-2.0;
	};

	# DCONF
	".config/dconf" = {
	  source = ./dconf;
	};

	# XSETTINGSD
	".config/xsettingsd" = {
	  source = ./xsettingsd;
	};

       };
     };
   };
 };
}





