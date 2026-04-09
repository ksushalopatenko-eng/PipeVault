#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PATH="/usr/local/bin/pipevault"

echo "Installing PipeVault..."

ln -sf "$SCRIPT_DIR/pipevault" "$INSTALL_PATH"
chmod +x "$SCRIPT_DIR/pipevault"

echo "Done! Run: pipevault"
