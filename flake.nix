{
  description = "Minimal finix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
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

    hjem-rum = {
        url = "github:snugnug/hjem-rum";
        # You may want hjem-rum to use your defined nixpkgs input to
        # minimize redundancies.
        inputs.nixpkgs.follows = "nixpkgs";
        # Same goes for hjem, to avoid discrepancies between the version
        # you use directly and the one hjem-rum uses.
        inputs.hjem.follows = "hjem";
    };

    # Helium
    helium = {
     url = "github:schembriaiden/helium-browser-nix-flake";
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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
       inputs.nix-cachyos-kernel.overlays.pinned
      ];
    };
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
    };
    lib-stable = inputs.nixpkgs-stable.lib;

    specialArgs = {
      modulesPath = toString nixpkgs + "/nixos/modules";
      inherit system;
      inputs = inputs // {
        pkgs-stable = pkgs-stable;
      };
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
	hyprland
	bluetooth
	rtkit
	xwayland-satellite
	chronyd
	fwupd
	brightnessctl
	inputs.spicetify-nix.nixosModules.default
	inputs.hjem.finixModules.default
      ];

      inherit specialArgs;
    };
  };
}
