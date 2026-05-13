{  pkgs, ... }:

let
  # Local derivation example
  cage-xtmapper = pkgs.stdenv.mkDerivation {
    pname = "cage-xtmapper";
    version = "1.0";
    src = ./cage-xtmapper-v0.2.0.tar;

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
  };
in
  {
  environment.systemPackages = [
    cage-xtmapper
  ];
} 
