{
  description = "A Nix flake for Data Mining";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          shellHook = "
            echo 'Entering a jupyter notebook shell for data mining'
          ";
          packages = with pkgs.python311Packages; [
            ipython
            scipy
            pandas
            numpy
            jupyterlab
            matplotlib
            notebook
            networkx
            gensim
          ];
        };
      });
    };
}
