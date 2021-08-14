#!/bin/bash

if mount | grep " / " | grep -q overlay
then
  exit
else
  sudo sed -i '/^\/usr\/local\/bin\/postinstall-actions.sh/d' /etc/init.d/after.local

  # Fix XDM and reboot
  /usr/sbin/rcxdm stop
  sleep 5
  /usr/local/rcxdm start
  sleep 5
  reboot
fi
