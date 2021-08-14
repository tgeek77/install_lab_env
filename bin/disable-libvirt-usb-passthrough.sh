#!/bin/bash

if [ -e /usr/bin/spice-client-glib-usb-acl-helper ]
then
  echo "Disabling Libvirt USB passthrough ..."
  echo -e "COMMAND: sudo chmod u-s /usr/bin/spice-client-glib-usb-acl-helper"
  sudo chmod u-s /usr/bin/spice-client-glib-usb-acl-helper
  echo "Done"
fi
