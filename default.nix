scope@{ pkgs ? import <nixpkgs> { } }:

pkgs.buildEnv {
  name = "website-env";
  paths = with pkgs;
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
    ] ++ stdenv.lib.optional stdenv.isDarwin [ Security libiconv ];
  passthru = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LC_ALL = "en_US.UTF-8";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    CURL_CA_BUNDLE = "${pkgs.cacert}/etc/ca-bundle.crt";
    CARGO_TERM_COLOR = "always";
    RUST_BACKTRACE = "full";
  };
}
