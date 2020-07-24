scope@{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs;
    [
      git
      bash
      direnv
      binutils
      stdenv
      bashInteractive
      cacert
      gcc
      cmake
      pkg-config
      openssl
      bundler
      (glibcLocales.override { locales = [ "en_US.UTF-8" ]; })
      remarshal
      snappy
      gnumake
      autoconf
      zlib
    ] ++ stdenv.lib.optional stdenv.isDarwin [ Security libiconv ];
}
