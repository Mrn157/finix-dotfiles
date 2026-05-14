{
  description = "Minimal finix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    finix.url = "github:finix-community/finix?ref=main";
    
    # NVChad
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # Do not override its nixpkgs input, otherwise there can be mismatch between patches and kernel version
    };

    # Spicetify

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # Hjem
    hjem = {
      url = "github:r0chd/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = inputs@{ self, nixpkgs, finix, home-manager, ... }: 
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    extraSpecialArgs = { inherit inputs pkgs; };  # <- passing inputs to the attribute set for home-manager
  in {
    nixosConfigurations.hp = finix.lib.finixSystem {
      inherit (pkgs) lib;

      modules = with finix.nixosModules; [
        {
          nixpkgs.pkgs = nixpkgs.lib.mkDefault pkgs;
        }
        (./finix/configuration.nix)
        nix-daemon
        openssh
        sysklogd
        limine
        sudo
        polkit
        getty
        bash
        dhcpcd
        iwd
	niri
	bluetooth
	rtkit
	xwayland-satellite
	chronyd
	fwupd
	inputs.spicetify-nix.nixosModules.default
	inputs.hjem.finixModules.default
      ];

      specialArgs = {
        modulesPath = toString nixpkgs + "/nixos/modules";
        inherit inputs;
      };
    };
  };
}
