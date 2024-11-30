{
  description = "A Nix flake a development using a jupyter notebook for Data Mining";

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
            echo 'Entering a jupyter notebook shell for image proccessing'
          ";
          packages = with pkgs; [
            nodejs_22
            nodePackages.npm

           ] 
          ++
          (with pkgs.python3Packages; [
            ipython
            scipy
            imutils
            ipywidgets
            pandas
            seaborn
            numpy
            jupyterlab
            matplotlib
            notebook

          ]);
        };
      });
    };
}
