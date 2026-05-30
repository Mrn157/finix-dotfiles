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
         "Pictures/wallpaper.jpg" = {
           source = ./wallpaper.jpg;
         };
       };
     };
   };
 };
}
