#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SYNC_DIR="$CONFIG_DIR/omarchy-theme-sync"
OMARCHY_HOOKS_DIR="$CONFIG_DIR/omarchy/hooks"
OMARCHY_BIN_DIR="$HOME/.local/share/omarchy/bin"

# Ensure directories exist
mkdir -p "$SYNC_DIR" "$OMARCHY_HOOKS_DIR" "$OMARCHY_BIN_DIR"

# Copy the main script to bin and make it executable
cp ./omarchy-theme-sync "$OMARCHY_BIN_DIR/"
chmod 755 "$OMARCHY_BIN_DIR/omarchy-theme-sync"

# Handle theme-set hook
if [[ -f "$OMARCHY_HOOKS_DIR/theme-set.sample" ]]; then
    mv "$OMARCHY_HOOKS_DIR/theme-set.sample" "$OMARCHY_HOOKS_DIR/theme-set"
fi

if [[ ! -f "$OMARCHY_HOOKS_DIR/theme-set" ]]; then
    touch "$OMARCHY_HOOKS_DIR/theme-set"
    echo "#!/usr/bin/env bash" >> "$OMARCHY_HOOKS_DIR/theme-set"
fi

chmod 755 "$OMARCHY_HOOKS_DIR/theme-set"

# Append the command if it's not already in the file
grep -qxF "omarchy-theme-sync" "$OMARCHY_HOOKS_DIR/theme-set" || \
    echo "omarchy-theme-sync" >> "$OMARCHY_HOOKS_DIR/theme-set"

# Copy colors and config files
cp ./colors/* "$SYNC_DIR/"

# Preserve user profignore files
declare -A saved_profignores
for pf in "$SYNC_DIR"/*/profignore; do
    [[ -f "$pf" ]] && saved_profignores["$pf"]="$(cat "$pf")"
done

cp -r ./config/* "$SYNC_DIR/"

# Restore preserved profignore files
for pf in "${!saved_profignores[@]}"; do
    echo "${saved_profignores[$pf]}" > "$pf"
done

echo "Installation complete!"
