#!/usr/bin/env bash
# install-ebgaramond.sh — make the LaTeX `ebgaramond` package available
# on Debian/WSL so `pdflatex resume.tex` builds.
#
# Handles both TeX Live flavors:
#   - Debian-packaged TeX Live  -> apt (fonts live in texlive-fonts-extra)
#   - Vanilla TeX Live (tlmgr)  -> tlmgr install
set -euo pipefail

if kpsewhich ebgaramond.sty >/dev/null 2>&1; then
  echo "ebgaramond already installed — nothing to do."
  exit 0
fi

if ! command -v pdflatex >/dev/null 2>&1; then
  echo "No TeX found. Installing a base TeX Live first..."
  sudo apt-get update
  sudo apt-get install -y texlive-latex-base texlive-latex-recommended texlive-latex-extra
fi

# Nix-provided TeX Live? Immutable — tlmgr can't install into it.
if command -v pdflatex >/dev/null 2>&1 && readlink -f "$(command -v pdflatex)" | grep -q '^/nix/store/'; then
  cat <<'EOF'
Your TeX Live comes from Nix, which is read-only, so nothing gets installed
into it. This repo ships a shell.nix that layers the missing packages
(ebgaramond + its fontaxes dependency, enumitem, titlesec) on top of
scheme-medium. Build with:

  nix-shell --run 'pdflatex resume.tex'

(Or add ebgaramond, fontaxes, enumitem, and titlesec to the
texlive.withPackages list in your Home Manager / Nix config to fix it
globally.)
EOF
  exit 0
fi

# Vanilla TeX Live? (tlmgr present and usable)
if command -v tlmgr >/dev/null 2>&1 && tlmgr version >/dev/null 2>&1; then
  echo "Installing via tlmgr..."
  tlmgr install ebgaramond ebgaramond-maths || sudo tlmgr install ebgaramond ebgaramond-maths
else
  echo "Installing via apt (texlive-fonts-extra)..."
  sudo apt-get update
  sudo apt-get install -y texlive-fonts-extra
fi

kpsewhich ebgaramond.sty >/dev/null 2>&1 \
  && echo "Done — ebgaramond is available. Build with: pdflatex resume.tex" \
  || { echo "Install ran but ebgaramond.sty still not found — check your TeX setup."; exit 1; }
