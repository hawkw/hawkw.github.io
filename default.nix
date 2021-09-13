with import <nixpkgs> { };

let
  jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in stdenv.mkDerivation rec {
  name = "jekyll_env";
  buildInputs = [ jekyll_env ruby bundler ];
}
