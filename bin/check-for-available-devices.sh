#!/bin/bash

#############################################################################
#                         Global Variables
#############################################################################

#############################################################################
#                            Functions
#############################################################################

check_for_root() {
  if [ $(whoami) != root ]
  then
    echo
    echo "ERROR: You must be root to run this script."
    echo
    exit
  fi
}

check_for_available_devices() {
  local MOUNTED_DEVICE_LIST=$(mount | awk '{ print $1 }' | uniq | grep  "^/.*")
  local ALL_DEVICES=$(fdisk -l | grep "^/.*" | awk '{ print $1 }')

  for DEV in ${ALL_DEVICES}
  do
    if ! echo ${MOUNTED_DEVICE_LIST} | grep -q ${DEV}
    then
     if ! grep -q ${DEV} /proc/swaps
     then
       local AVAILABLE_DEVICES="${AVAILABLE_DEVICES} ${DEV}"
     fi
    fi
  done

  if [ -z ${AVAILABLE_DEVICES} ] 
  then 
    echo
    echo "No available devices found" 
    echo
  else 
    echo
    echo "Potentially Available Devices:"
    echo "-------------------------------"
    echo ${AVAILABLE_DEVICES} 
    echo
  fi
}

#############################################################################
#                          Main Code Body
#############################################################################

check_for_root
check_for_available_devices

