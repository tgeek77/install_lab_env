#!/bin/bash

#############################################################################
#                         Global Variables
#############################################################################

HOME_DIR_DEV=$1

#############################################################################
#                            Functions
#############################################################################

usage() {
  echo
  echo "USAGE: $0 [<home_device>]"
  echo
}

check_for_tty() {
  if ps | head -n 2 | tail -n 1 | awk '{ print $2 }' | grep pts
  then
    echo
    echo "ERROR: You must run this command from a TTY not in a GUI terminal."
    echo
    exit 1
  fi
}

check_for_root() {
  if [ $(whoami) != root ]
  then
    echo
    echo "ERROR: You must be root to run this script."
    echo
    echo "       You should log in directly as root rather than using sudo or su."
    echo
    exit 2
  fi
}

check_for_home_dev() {
  if [ -z ${HOME_DIR_DEV} ]
  then
    echo
    echo "ERROR: You must supply the device file for the home directory device."
    echo
    usage
    exit 3
  else
    if ! [ -e ${HOME_DIR_DEV} ]
    then
      echo
      echo "ERROR: The supplied home directory device file does not exist."
      echo
      exit 4
    fi
  fi
}

stop_xdm() {
  echo
  echo "Stopping XDM ..."
  rcxdm stop
  echo 
}

copy_current_home_files() {
  echo "Copying current /home/* to new home device ..."
  mount ${HOME_DIR_DEV} /mnt
  rsync -a /home/ /mnt/
  umount ${HOME_DIR_DEV}
  echo
}

mount_home_dev() {
  echo "Mounting the new home device on /home"
  mount ${HOME_DIR_DEV} /home
  echo 
}

start_xdm() {
  echo "Restarting XDM ..."
  rcxdm start
  echo 
}

#############################################################################
#                          Main Code Body
#############################################################################

check_for_tty
check_for_root
check_for_home_dev
stop_xdm
copy_current_home_files
mount_home_dev
start_sxm
