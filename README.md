# Omarchy-Theme-Sync (with firefox support)

Many thanks to [beaterblank](https://github.com/beaterblank) for [making omarchy's theme syncing more accessible](https://github.com/beaterblank/omarchy-theme-sync). This is a fork of their repo adding support for firefox (PR incoming). Zen-browser support forthcoming. You can find beaterblank's original README below.

All you have to do is run `install.sh`. Themes should sync any time you change omarchy's theme. Firefox must be restarted for the change to take effect.

If it turns out you don't like it:
- If you did not previously have a `user.js`, you can navigate to `.mozilla/firefox/<your_profile_folder>/user.js` and delete the file. This should remove settings overriding firefox's default `prefs.js`
- Otherwise, manually rollback `user.js` by removing/updating the following settings the script adds/changes in this file:
  1. `toolkit.legacyUserProfileCustomizations.stylesheets` -> enables
  2. `extensions.activeThemeID` -> attempts to set current firefox theme back to default
  3. `layout.css.prefers-color-scheme.content-override`

## ⭐IMPORTANT ⭐
Make sure to switch firefox to its default theme WITH syncing of light/dark mode based on OS settings enabled. You can do this before or after installation.
- The script will detect the current theme and **attempt** to override/swap back to default for you via `user.js` / `extensions.json`.
  - *This method is currently imperfect/untested. If it doesn't work, manually switch to another theme, and back to the default firefox theme in `about:addons > Themes`.*
- 🌠 Each Firefox profile updated MUST be fully shut-down and restarted for themes to apply. It does not currently support hot-reloading of `userChrome.css` styling without the Browser Toolbox mode devtools interface (not recommended).

## Changes from the default repo:

`install.sh`
- Changed `chmod +x omarchy-theme-sync` to `chmod 755 omarchy-theme-sync` to align with other executable bin permissions
- Permissions are applied *after* `omarchy-theme-sync` is copied to `$OMARCHY_BIN_DIR`

`omarchy-theme-sync`
- firefox
  - Added `config/firefox` template folder with:
    - `userChrome.css` -> Styles the browser interface
    - `userContent.css` -> Styles default home, new tab, and blank pages
  - Syncing the theme across all firefox profiles required some extra logic:
    - Added firefox-specific conditional in `replace_vars()` to route the firefox subdirectory through `sync_firefox()` instead of the normal copy logic
    - Added `sync_firefox()` function to handle syncing theme files across all Firefox profiles parsed from `profiles.ini`
    - Added `ensure_user_pref()` helper to idempotently manage preferences in each profile's `user.js`
  - Added theme detection via `extensions.json` using `jq`, resetting non-default themes back to `default-theme@mozilla.org`
  - Enforced three `user.js` prefs per profile: `toolkit.legacyUserProfileCustomizations.stylesheets`, `extensions.activeThemeID`, and `layout.css.prefers-color-scheme.content-override`

## Where is `zen-browser` support?
Because zen is based on firefox, support for it can be added using this same method. BUT, it requires a `userChrome.css` tailored for it (and perhaps a `userContent.css` too). Sync logic specific to zen also needs to be added (e.g. `sync_zenbrowser()` in `omarchy-theme-sync` with multi-profile imports).

I worked on this a bit after adding firefox support, but it's unfinished. I'll include a separate branch with what I've done so far.

---

# Omarchy Theme Sync

**Automatically updates your configuration files when your Omarchy theme changes.**

This script watches your current Omarchy theme for changes and dynamically replaces color placeholders in your configuration files with the actual values from the theme.

* Watches `~/.config/omarchy/current/theme/` for updates.
* Replaces `${var_name}` placeholders in your app configuration files with the corresponding values from `colors.toml`.
* Copies the processed configuration files to the destination specified in each app’s `dir` file.

## Directory Structure

```
~/.config/omarchy/current/theme/        # Active theme folder
~/.config/omarchy-theme-sync/
└─ <app_name>/
    ├─ <config_files>                # Files with ${var_name} placeholders
    └─ dir                           # File containing the actual destination path
```

* `colors.toml` contains the theme variables (e.g., `foreground = "#a9b1d6"`).
* Each app folder in `~/.config/omarchy-theme-sync/
` must have a `dir` file specifying the destination path.
* Placeholders like `${foreground}` in the configuration files will be replaced with the actual values from `colors.toml`.

### Example config
```
~/.config/omarchy-theme-sync/zen-cal/dir
    $HOME/.config/zen-cal
~/.config/omarchy-theme-sync/zen-cal/zen-cal.conf
    # Zen-Cal color configuration
    today      = ${selection_background}
    today_text = ${selection_foreground}
    headings   = ${accent}
    text       = ${foreground}
    weekends   = ${color2}
```


## Usage

### Installation

1. **Run the installer**

```bash
chmod +x ./install.sh
./install.sh
```


### Uninstallation

```bash
chmod +x ./uninstall.sh
./uninstall.sh
```

## How It Works

1. Detects the active color scheme (`catppuccin-latte` for light or `catppuccin-mocha` for dark) if `colors.toml` is missing.
2. Iterates over all subdirectories in the sync folder (`~/.config/omarchy-theme-sync/`).
3. Uses a temporary directory for processing to avoid overwriting files during replacement.
4. Recursively replaces all `${var_name}` placeholders with values from `colors.toml`.
5. Moves the processed files to the existing destination directory specified in the `dir` file.

## Notes

* Only directories with a `dir` file are processed.
* If the destination path does not exist, the folder is skipped.
* Changes in the theme folder are automatically applied to your configurations in real-time.
