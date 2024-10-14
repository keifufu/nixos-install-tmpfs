{
  description = "nixos-install but it works on tmpfs im too lazy to pr it works for me ok thx";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: {
    packages = nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: 
      let
        pkgs = import nixpkgs { inherit system; };
        nixosInstallSrc = pkgs.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "51b47621ac00d9d815dec6beb0958f96d2f6eb11";
          sha256 = "sha256-MbNy10+R6wp2ChvxD3mEqBjGQVBJMbu1bVonj5BZNt4=";
        };
        patch = ./tmpdir.patch;
      in
        pkgs.stdenv.mkDerivation rec {
          pname = "nixos-install";
          version = "1.0.0";
          src = pkgs.substituteAll {
            src = "${nixosInstallSrc}/pkgs/by-name/ni/nixos-install/nixos-install.sh";
            runtimeShell = pkgs.runtimeShell;
            path = pkgs.lib.makeBinPath [ pkgs.jq pkgs.nixos-enter pkgs.util-linuxMinimal ];
          };
          dontUnpack = true;
          buildInputs = [
            pkgs.jq
            pkgs.nixos-enter
            pkgs.util-linuxMinimal
            pkgs.installShellFiles
          ];
          nativeBuildInputs = [ pkgs.installShellFiles ];
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/nixos-install
            patch $out/bin/nixos-install < ${patch}
            chmod +x $out/bin/nixos-install
          '';
          meta = {
            description = "Install bootloader and NixOS";
            homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-install";
            license = pkgs.lib.licenses.mit;
            mainProgram = "nixos-install";
          };
        });
    defaultPackage.x86_64-linux = self.packages.x86_64-linux;
    defaultPackage.aarch64-linux = self.packages.aarch64-linux;
  };
}
