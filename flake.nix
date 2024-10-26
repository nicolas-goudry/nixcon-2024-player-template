{
  description = "NixCon 2024 - NixOS on garnix: Production-grade hosting as a game";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.garnix-lib = {
    url = "github:garnix-io/garnix-lib";
    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, garnix-lib, flake-utils }:
    let
      system = "x86_64-linux";
    in
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = {
          webserver = pkgs.writeScriptBin "server" ''
            ${pkgs.nodejs_22}/bin/node ${./src/index.js}
          '';
          default = packages.webserver;
        };
        apps.default = {
          type = "app";
          program = pkgs.lib.getExe (
            pkgs.writeShellApplication {
              name = "start-webserver";
              runtimeEnv = {
                PORT = "8080";
              };
              text = ''
                ${pkgs.lib.getExe packages.webserver}
              '';
            }
          );
        };
      }))
    //
    {
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          garnix-lib.nixosModules.garnix
          self.nixosModules.nixcon-garnix-player-module
          ({ pkgs, ... }: {
            playerConfig = {
              # Your github user:
              githubLogin = "nicolas-goudry";
              # You only need to change this if you changed the forked repo name.
              githubRepo = "nixcon-2024-player-template";
              # The nix derivation that will be used as the server process. It
              # should open a webserver on port 8080.
              # The port is also provided to the process as the environment variable "PORT".
              webserver = self.packages.${system}.webserver;
              # If you want to log in to your deployed server, put your SSH key
              # here:
              sshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDI2fmFXsbA9nboZzQeiKCzGMrsBmmKNvLDTC7m09DIH3f+JeT0Ej01KNzf47JyDPaQ9RIZHzig1iCHmUuVeIEmaSBNN8RT0lmHAYXDc2zw/wXzlBJLrevGgdZHEk0MEe66798jo1vs2AJ66E2H5ZG4xmmxGfQWRrnrYlURN75mfCQgMOGK/uzwVvsVAsGbv+hO+EA1Y0bOXodFbHQAgknZM3Kt6d+Iv4hAqWxftmVImjzTS31oLuptoL9ztvBHNvDc7kgD/d/Mcmie/Yy8hUp6dn1mznM+OI3vcRYbMKybFM8U0da2d1/7JYjC7RuhObRzA0dcqmIFxogJQM7LOIXpoTOUh6dN+I5eVK8xDDBTRImXqWGgx3b0gv8IE2cyeyuXmOdltnhqgtaaJkNOJJ8JCbBrG/6JUjooMODA8pCYlxe1HOjIycAxnpmHaTLu8kq6a+uLHackSiHT2Lj2+frFwAx/dwZBUsCVYY5fQjF2WuFzom94jXyvwEonFgtX26ATt3xCllOm1MJ2aleSDoGg2XPE42aRZjuutPcnvZNTYJ/n3GdT4uQqz7Z0gH3fQ1iyWs8Du0vwCselaIGNDIc+PiZl2OZBI1/bbwgrNDkE1OFOSOHkpZcBnL2vOhpoo1KEFintXswIiwp5nqAZTGM8BXGiSJAAUpfa+s00FZzg+Q== goudry.nicolas@gmail.com";
            };
          })
        ];
      };

      nixosModules.nixcon-garnix-player-module = ./nixcon-garnix-player-module.nix;
      nixosModules.default = self.nixosModules.nixcon-garnix-player-module;

      # Remove before starting the workshop - this is just for development
      checks = import ./checks.nix { inherit nixpkgs self; };
    };
}

