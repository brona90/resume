# resume

Latex based resume

## Building

The résumé uses EB Garamond plus `enumitem` and `titlesec`, which the base
Nix `texlive.combined.scheme-medium` omits. A `shell.nix` layers them on:

```sh
nix-shell --run 'pdflatex resume.tex'
```

On Debian/WSL (non-Nix TeX), run `./install-ebgaramond.sh` first to pull the
packages via apt or tlmgr, then `pdflatex resume.tex`.

[![Build LaTeX document](https://github.com/brona90/resume/actions/workflows/latex.yml/badge.svg)](https://github.com/brona90/resume/actions/workflows/latex.yml)
