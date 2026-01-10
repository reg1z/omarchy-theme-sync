#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SYNC_DIR="$CONFIG_DIR/omarchy-theme-sync"

rm -rf "$SYNC_DIR"

systemctl --user stop omarchy-theme-sync.service
systemctl --user disable omarchy-theme-sync.service

rm "$HOME/.config/systemd/user/omarchy-theme-sync.service"
