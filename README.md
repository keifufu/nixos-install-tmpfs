# nixos-install-tmpfs

Literally just [nixos-install.sh](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ni/nixos-install/nixos-install.sh) but with one patch allowing you to pass --tmpdir to prevent nixos-install from exceeding tmpfs capacity while trying to do shit in /mnt/tmp.whatever..

You probably shouldn't use this. This is just for me since I can't be bothered to PR something.

Usage: `nix run github:keifufu/nixos-install-tmpfs --flake <whatever> --tmpdir /mnt/tmp`
