#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SYNC_DIR="$CONFIG_DIR/omarchy-theme-sync"
OMARCHY_HOOKS_DIR="$CONFIG_DIR/omarchy/hooks"
OMARCHY_BIN_DIR="$HOME/.local/share/omarchy/bin"

# Remove the main binary
rm -f "$OMARCHY_BIN_DIR/omarchy-theme-sync"

# Remove sync directory
rm -rf "$SYNC_DIR"

# Remove line from theme-set hook if present
if [[ -f "$OMARCHY_HOOKS_DIR/theme-set" ]]; then
    sed -i '/^omarchy-theme-sync$/d' "$OMARCHY_HOOKS_DIR/theme-set"
    
    # If hook is now empty, remove it
    if [[ ! -s "$OMARCHY_HOOKS_DIR/theme-set" ]]; then
        rm -f "$OMARCHY_HOOKS_DIR/theme-set"
    fi
fi

echo "Uninstallation complete!"

