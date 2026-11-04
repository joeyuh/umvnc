#!/usr/bin/env bash
# Copies umvpn and umvnc into ~/.local/bin (make sure that's on your PATH).
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p ~/.local/bin
install -m755 umvpn umvnc ~/.local/bin/
echo "Installed umvpn and umvnc to ~/.local/bin"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "Note: add ~/.local/bin to your PATH" ;; esac
