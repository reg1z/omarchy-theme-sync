# omarchy-theme-sync-ctl
Automatically updates your configuration files when your **Omarchy theme** changes.

* The script watches `~/.config/omarchy/current/theme/` for changes.
* When a theme changes, it replaces placeholders in the files under `~/.config/omarchy-theme-sync/.config/` with actual color values and copies them to `~/.config/`.

> Note : in `~/.config/omarchy-theme-sync/.config/` colors indicated with  `${var_name}` will be replaced with actual `var_name` from `colors.toml`
