#!/bin/bash
# version: 1.0.0
# date: 2019-05-08

##############################################################################
#                           Global Variables
##############################################################################

### Colors ###
RED='\e[0;31m'
LTRED='\e[1;31m'
BLUE='\e[0;34m'
LTBLUE='\e[1;34m'
GREEN='\e[0;32m'
LTGREEN='\e[1;32m'
ORANGE='\e[0;33m'
YELLOW='\e[1;33m'
CYAN='\e[0;36m'
LTCYAN='\e[1;36m'
PURPLE='\e[0;35m'
LTPURPLE='\e[1;35m'
GRAY='\e[1;30m'
LTGRAY='\e[0;37m'
WHITE='\e[1;37m'
NC='\e[0m'
##############
#echo -e "${LTBLUE}==============================================================${NC}"
#echo -e "${LTBLUE}${NC}"
#echo -e "${LTBLUE}==============================================================${NC}"
#echo -e "${LTCYAN}  -${NC}"
#echo -e "${LTGREEN}COMMAND:${GRAY} ${NC}"
#echo -e "${LTRED}ERROR: ${NC}"
#echo -e "${LTPURPLE}  VAR=${GRAY}${VAR}${NC}"
##############

##############################################################################
#                          Functions
##############################################################################

usage() {
  echo "USAGE: ${0} <rootfs_dir>"
  echo
}

##############################################################################
#                           Main Code Body
##############################################################################

if [ -z ${1} ]
then
  echo
  echo -e "${LTRED}ERROR: You must supply a rootfs directory to unprep.${NC}"
  echo
  usage
  exit
else
  ROOTFS_DIR=${1}

  echo -e "${LTBLUE}==============================================================${NC}"
  echo -e "${LTBLUE} Unpreparing ${ROOTFS_DIR} chroot${NC}"
  echo -e "${LTBLUE}==============================================================${NC}"

  if [ -d ${ROOTFS_DIR} ]
  then
    echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R ${ROOTFS_DIR}/dev${NC}"
    sudo umount -R ${ROOTFS_DIR}/dev

    echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R ${ROOTFS_DIR}/proc${NC}"
    sudo umount -R ${ROOTFS_DIR}/proc

    echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R ${ROOTFS_DIR}/sys${NC}"
    sudo umount -R ${ROOTFS_DIR}/sys

  # if grep -q /home ${ROOTFS_DIR}/etc/fstab
  # then
  #   echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R ${ROOTFS_DIR}/home${NC}"
  #   sudo umount -R /rescue/home
  # fi
  #
  # if grep -q /boot/efi ${ROOTFS_DIR}/etc/fstab
  # then
  #   echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R ${ROOTFS_DIR}/boot/efi${NC}"
  #   sudo umount -R ${ROOTFS_DIR}/boot/efi
  # fi

    echo
  else
    echo -e "${LTBLUE}${ROOTFS_DIR} doesn't seem to exist. Exiting.${NC}"
    echo
  fi
fi
