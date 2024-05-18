#!/bin/bash

cd /tmp/deb/installation
nvim --appimage-extract

mv squashfs-root/usr/bin/* ~/.local/bin/
mv squashfs-root/usr/share/* ~/.local/share/
mv squashfs-root/usr/lib/* ~/.local/lib/


