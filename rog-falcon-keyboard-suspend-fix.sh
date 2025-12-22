#!/bin/bash
# Stop Asus ROG Falchion mechanical keyboard from sending POWER and SLEEP key presses when the keyboard goes to sleep
# From https://gist.github.com/jnettlet/afb20a048b8720f3b4eb8506d8b05643#file-99-asus-falchion-hwdb
# May require reboot to take effect

sudo cp 99-asus-falchion.hwdb /etc/udev/hwdb.d/99-rog-falcon.hwdb
sudo systemd-hwdb update
sudo udevadm trigger
