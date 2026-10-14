#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="${HOME_BIN_DIR:-${HOME}/.local/bin/}"
ENTER_BIN_TARGET="$BIN_DIR/enter"
ENVS_DIR_TARGET="${ENTER_ENVS_DIR:-${HOME}/envs}"

ENTER_SCRIPT="${SCRIPT_DIR}/enter"
ENVS="${SCRIPT_DIR}/envs"

# Warn about nonstandard path
if [[ -n ${ENTER_ENVS_DIR:-} ]]; then
    echo "Note: Installing envs in nonstandard location ($ENVS_DIR_TARGET). You need to set up a shim so that the enter script has access to the ENTER_ENVS_DIR environment varible."
fi

# Ensure source files exist.
if [[ ! -f "$ENTER_SCRIPT" ]]; then
    echo "Error: Required file not found: $ENTER_SCRIPT" >&2
    exit 1
fi
if [[ ! -d "$ENVS" ]]; then
    echo "Error: Required directory not found: $ENVS" >&2
    exit 1
fi

# Refuse to overwrite existing files
if [[ -e "$ENTER_BIN_TARGET" ]]; then
    echo "Error: ${ENTER_BIN_TARGET} already exists. Refusing to overwrite it." >&2
    exit 1
fi
if [[ -e "$ENVS_DIR_TARGET" ]]; then
    echo "Error: ${ENVS_DIR_TARGET} already exists. Refusing to overwrite it." >&2
    exit 1
fi

mkdir -p "$BIN_DIR"

ln -s "$ENTER_SCRIPT" "$ENTER_BIN_TARGET"
ln -s "$ENVS" "$ENVS_DIR_TARGET"

echo "Installed symlinks:"
echo "  enter -> $ENTER_BIN_TARGET"
echo "  envs -> $ENVS_DIR_TARGET"
