#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
THEME_DIR="$CONFIG_DIR/omarchy/current/theme"
SYNC_DIR="$CONFIG_DIR/omarchy-theme-sync"

# Default colors
get_default_colors() {
    mode=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || echo "'prefer-light'")
    if [[ $mode == "'prefer-dark'" ]]; then
        COLORS="catpuccin-mocha"
    else
        COLORS="catpuccin-latte"
    fi
    echo "$COLORS"
}

# Load colors.toml
load_colors() {
    if [[ -f "$THEME_DIR/colors.toml" ]]; then
        COLORS_FILE="$THEME_DIR/colors.toml"
    else
        echo "No colors.toml found, using default"
        DEFAULT=$(get_default_colors)
        COLORS_FILE="$SYNC_DIR/colors/$DEFAULT/colors.toml"
    fi
}

# Replace variables in files
replace_vars() {
    local src="$1"
    local dst="$2"
    local tmp
    tmp=$(mktemp -d)

    # copy source config to temporary directory
    cp -r "$src"/. "$tmp"/

    # find all placeholders recursively in tmp
    while IFS= read -r var; do
        # get the value from colors.toml
        value=$(grep "^$var\s*=" "$COLORS_FILE" | cut -d'=' -f2 | tr -d ' "')
        [[ -n "$value" ]] && \
        # replace in all files recursively in tmp
        find "$tmp" -type f -exec sed -i "s|\${$var}|$value|g" {} +
    done < <(grep -rhoP '\$\{\K[^}]+' "$tmp" | sort -u)

    # move the updated temp folder to destination
    mv "$tmp"/* "$dst"/

    # clean up temp
    rm -rf "$tmp"
}


# Watch for changes
watch_theme() {
    inotifywait -m -e close_write,moved_to,create "$THEME_DIR" |
    while read -r directory events filename; do
        echo "Detected theme change: $filename"
        load_colors
        replace_vars "$SYNC_DIR/.config" "$CONFIG_DIR"
    done
}

# Start watching
watch_theme
