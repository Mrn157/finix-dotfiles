{ pkgs,  ... }:
  pkgs.stdenv.mkDerivation {
  pname = "cage-xtmapper";
  version = "1.0";
  # src = ./cage-xtmapper-v0.2.0.tar;
  src = pkgs.fetchurl {
    url = "https://github.com/Xtr126/cage-xtmapper/releases/download/v20250920/cage-xtmapper-v0.2.0.tar";
    hash = "sha256-YixHjSsthYC52ozdJ/ZF+h6BxEKRLha/uRixJfunIgU=";
  };

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = with pkgs; [
    wayland libdrm libxkbcommon pixman mesa vulkan-loader systemd seatd
    libxcb xcbutilrenderutil xcbutil libGL
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp local/bin/cage_xtmapper $out/bin/
    cp local/bin/cage_xtmapper.sh $out/bin/
    chmod +x $out/bin/*
  '';
}
