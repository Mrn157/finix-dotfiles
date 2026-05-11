{ pkgs, ... }: 
  with pkgs; (dwl.overrideAttrs (oldAttrs: rec {
  version = "ab4cb6e28365cf8754d6d3bdd293c05abfc27e26";
  src = builtins.fetchGit {
    url = "https://codeberg.org/dwl/dwl";
    rev = version;
  };

  buildInputs = oldAttrs.buildInputs ++ [
    wlroots_0_19
    fcft
    libdrm
  ];

  patches = [
    (fetchpatch {
      excludes = [ "config.def.h" ];
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/bar/bar.patch";
      sha256 = "sha256-EZNorxpiNLa4q70vz4uUAiH6x36N/F5oPQ0iJp3m5Nw=";
    })

    (fetchpatch {
      excludes = [ "config.def.h" ];
      url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/autostart/autostart.patch";
      sha256 = "sha256-f+41++4R22HYtAwHbaRk05TMKCC8mgspwBuNvnmbQfU=";
     })
     (fetchpatch {
       excludes = [ "config.def.h" ];
       url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/cursortheme/cursortheme.patch";
       sha256 = "sha256-E544m6ca2lYbjYxyThr3GQEhDqh2SDjryLV/g4X8Rt4=";
     })
  ];
  postPatch = ''
        cp ${./config.def.h} config.def.h
  '';
}))


