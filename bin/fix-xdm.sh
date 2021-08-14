#!/bin/bash

if ! /usr/sbin/rcxdm status | grep "^ *Active:" | grep -iq "active (running)"
then
  echo "Restarting XDM"
  echo "  -stopping"
  /usr/sbin/rcxdm stop
  sleep 5

  echo "  -starting"
  /usr/sbin/rcxdm start
  sleep 5

#  /sbin/reboot
else
  echo "XDM is already running"
fi

