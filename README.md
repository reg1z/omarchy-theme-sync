# Omarchy Theme Sync

**Automatically updates your configuration files when your Omarchy theme changes.**

This script watches your current Omarchy theme for changes and dynamically replaces color placeholders in your configuration files with the actual values from the theme.


## Features

* Watches `~/.config/omarchy/current/theme/` for updates.
* Replaces `${var_name}` placeholders in your app configuration files with the corresponding values from `colors.toml`.
* Copies the processed configuration files to the destination specified in each app’s `dir` file.
* Supports multiple apps and configuration directories.

## Directory Structure

```
~/.config/omarchy/current/theme/        # Active theme folder
~/.config/omarchy-theme-sync/
└─ config/
   └─ <app_name>/
      ├─ <config_files>                # Files with ${var_name} placeholders
      └─ dir                            # File containing the actual destination path
```

* `colors.toml` contains the theme variables (e.g., `foreground = "#a9b1d6"`).
* Each app folder in `.config/` must have a `dir` file specifying the destination path.
* Placeholders like `${foreground}` in the configuration files will be replaced with the actual values from `colors.toml`.

## Requirements

* `bash`
* `inotify-tools` (for monitoring file changes)
* `rsync`, `grep`, `sed` (common GNU utilities)


## Usage

1. **Ensure your directories are set up correctly**
   Each app configuration folder should include a `dir` file specifying the destination directory.

2. **Run the script**

```bash
./omarchy-theme-sync.sh
```

The script will start watching `~/.config/omarchy/current/theme/` for changes. When a change is detected:

* The latest colors are loaded from `colors.toml`.
* Placeholders in your configuration files are replaced with actual color values.
* Processed files are copied to the destination specified in the `dir` file.

## How It Works

1. Detects the active color scheme (`catppuccin-latte` for light or `catppuccin-mocha` for dark) if `colors.toml` is missing.
2. Iterates over all subdirectories in the sync folder (`~/.config/omarchy-theme-sync/.config/`).
3. Uses a temporary directory for processing to avoid overwriting files during replacement.
4. Recursively replaces all `${var_name}` placeholders with values from `colors.toml`.
5. Moves the processed files to the existing destination directory specified in the `dir` file.

## Notes

* Only directories with a `dir` file are processed.
* If the destination path does not exist, the folder is skipped.
* Changes in the theme folder are automatically applied to your configurations in real-time.
