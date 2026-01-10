#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SYNC_DIR="$CONFIG_DIR/omarchy-theme-sync"

mkdir "$SYNC_DIR/config/" -p
mkdir "$SYNC_DIR/colors/" -p

chmod +x ./omarchy-theme-sync.sh
cp ./omarchy-theme-sync.sh "$SYNC_DIR/"
cp ./colors "$SYNC_DIR" -r
cp ./config "$SYNC_DIR" -r

cp ./omarchy-theme-sync.service "$HOME/.config/systemd/user/"
cp ./omarchy-theme-sync.path "$HOME/.config/systemd/user/"

systemctl --user daemon-reload
systemctl --user enable --now omarchy-theme-sync.path
