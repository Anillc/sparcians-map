{
  outputs = inputs@{
    self, nixpkgs, flake-parts,
  }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    perSystem = { pkgs, self', ... }: {
      packages.sparta = pkgs.stdenv.mkDerivation rec {
        pname = "sparta";
        version = "map_v2.0.20";
        src = "${./.}/sparta";
        cmakeFlags = [
          "-DGIT_REPO_VERSION=${version}"
          "-DCMAKE_BUILD_TYPE=Release"
        ];
        buildInputs = with pkgs; [ boost186 yaml-cpp rapidjson sqlite zlib hdf5 ];
        # FindSparta.cmake will find dependencies, so keep this.
        propagatedBuildInputs = buildInputs;
        nativeBuildInputs = with pkgs; [ cmake cppcheck ];
      };
      devShells.default = pkgs.mkShell {
        inputsFrom = [ self'.packages.sparta ];
      };
    };
  };
}
