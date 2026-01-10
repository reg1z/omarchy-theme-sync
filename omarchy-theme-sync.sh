#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
THEME_DIR="$CONFIG_DIR/omarchy/current/"
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

    # Iterate over subdirectories only
    for sub in "$src"/*/; do
        # If not a directory skip the file
        [[ -d "$sub" ]] || continue

        # Read destination from 'dir' file inside the subdirectory
        local dest
        if [[ -f "$sub/dir" ]]; then
            dest=$(<"$sub/dir")
            [[ -d "$dest" ]] || { echo "Destination $dest does not exist, skipping $sub"; continue; }
        else
            echo "No dir file in $sub, skipping..."
            continue
        fi

        # Use a temporary folder for processing
        local tmp
        tmp=$(mktemp -d)

        # Copy subdirectory contents to temp (excluding the dir file)
        rsync -a --exclude 'dir' "$sub" "$tmp/"

        # Find all placeholders recursively in temp
        while IFS= read -r var; do
            # Get value from colors.toml
            local value
            value=$(grep "^$var\s*=" "$COLORS_FILE" | cut -d'=' -f2 | tr -d ' "')
            [[ -n "$value" ]] && \
            # Replace in all files recursively in temp
            find "$tmp" -type f -exec sed -i "s|\${$var}|$value|g" {} +
        done < <(grep -rhoP '\$\{\K[^}]+' "$tmp" | sort -u)

        # Move processed files to the existing destination
        mv "$tmp"/* "$dest"/

        # Clean temp
        rm -rf "$tmp"
    done
}


# Watch for changes
watch_theme() {
    inotifywait -m -e close_write,moved_to,create "$THEME_DIR" |
    while read -r directory events filename; do
        echo "Detected theme change: $filename"
        load_colors
        replace_vars "$SYNC_DIR/config/"
    done
}

# Start watching
watch_theme
