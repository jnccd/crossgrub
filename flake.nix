{
  description = "CrossGrub";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    numtide-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, numtide-utils, ... }@inputs:
    numtide-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        crossGrub = pkgs.stdenv.mkDerivation {
          pname = "crossgrub";
          version = "1.0.0";
          src = pkgs.fetchFromGitHub {
            owner = "jnccd";
            repo = "crossgrub";
            rev = "1bac404598a3bd105c36ed02cb79895779a471bb";
            hash = "sha256-TBekdpKmvPlUIdAUbkLfFJXZH8oGufVeMELosHw4tC0=";
          };

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/
            cp ./assets/*.png ./theme.txt ./*.pf2 $out/
            runHook postInstall
          '';

          passthru.updateScript = pkgs.nix-update-script { };

          meta = with pkgs.lib; {
            description = "A CrossCode-styled GRUB theme";
            license = lib.licenses.mit;
            platforms = platforms.linux;
          };
        };
      in {
        packages = {
          inherit crossGrub;
          default = crossGrub;
        };
        defaultPackage = crossGrub;
      });
}
