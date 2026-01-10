#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
SYNC_DIR="$CONFIG_DIR/omarchy-theme-sync"

mkdir "$SYNC_DIR/config/" -p
mkdir "$SYNC_DIR/colors/" -p

cp ./colors "$SYNC_DIR/colors" -r
cp ./config "$SYNC_DIR/config" -r
