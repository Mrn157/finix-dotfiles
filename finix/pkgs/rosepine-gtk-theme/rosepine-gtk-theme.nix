{ pkgs,  ... }:

pkgs.stdenv.mkDerivation {
  pname = "rose-pine-purple-dark-gtk-theme";
  version = "release";

    # if the file is local
    # src = ./modules/Rosepine-Purple-Dark;
    # if it is not, use this:
   src = pkgs.fetchurl {
    url = "https://github.com/Mrn157/Rosepine-Purple-Dark/archive/refs/tags/Release.tar.gz";
    hash = "sha256-VZPp7dCbKDAr3NXt4eqKgZMl2DZqv/TfkCiDsoQ1SQ8=";
   };

    # To fix the error > cp: missing destination file operand after ''
   sourceRoot = "Rosepine-Purple-Dark-Release/Rosepine-Purple-Dark";
      # Or use cp -r Rosepine-Purple-Dark/* $out/share/themes/Rosepine-Purple-Dark in installPhase
      # This works because after unpackPhase and sourceRoot is not set,
      # Nix will automatically pick the top directory of the ARCHIVE
      # (Which is Rosepine-Purple-Dark-Release)

   installPhase = ''
    mkdir -p $out/share/themes/Rosepine-Purple-Dark
    cp -r * $out/share/themes/Rosepine-Purple-Dark
   '';
}
