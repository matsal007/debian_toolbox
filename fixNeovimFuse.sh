#!/bin/bash

cd /tmp/deb/installation
nvim --appimage-extract

sudo mv squashfs-root/usr/bin/* ~/.local/bin/
sudo mv squashfs-root/usr/share/* ~/.local/share/
sudo mv squashfs-root/usr/lib/* ~/.local/lib/


