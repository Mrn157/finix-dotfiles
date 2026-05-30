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

	 # Bash Setup
         ".bash_profile" = {
	   source = ./.bash_profile;
	 };

       };
     };
   };
 };
}




