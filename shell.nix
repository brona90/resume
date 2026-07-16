# Reproducible build environment for the résumé.
#
#   nix-shell --run 'pdflatex resume.tex'
#
# Provides a TeX Live (scheme-medium) augmented with the three packages the
# résumé needs that the base scheme omits: ebgaramond (the EB Garamond font),
# enumitem (compact lists), and titlesec (section styling). Pinned to nixpkgs
# for reproducibility.
{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = [
    (pkgs.texliveMedium.withPackages (ps: [
      ps.ebgaramond
      ps.fontaxes # required by ebgaramond
      ps.enumitem
      ps.titlesec
    ]))
  ];
}
