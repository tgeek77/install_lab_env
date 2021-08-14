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
  usage
  exit
else
  if [ -e ${1} ]
  then
    ROOTFS_DIR=${1}
  else
    echo -e "${LTRED}ERROR: ${1} does not exist. Exiting.${NC}"
    exit
  fi
fi

echo -e "${LTBLUE}==============================================================${NC}"
echo -e "${LTBLUE} Preparing to chroot into ${ROOTFS_DIR}${NC}"
echo -e "${LTBLUE}==============================================================${NC}"

if [ -e "${ROOTFS_DIR}" ]
then
#  if grep -q "/boot/efi" ${ROOTFS_DIR}/etc/fstab
#  then
#    echo -e "${LTGREEN}COMMAND:${GRAY} sudo mount $(grep /boot/efi ${ROOTFS_DIR}/etc/fstab | awk '{ print $1 }') ${ROOTFS_DIR}/boot/efi${NC}"
#    sudo mount $(grep /boot/efi ${ROOTFS_DIR}/etc/fstab | awk '{ print $1 }') ${ROOTFS_DIR}/boot/efi
#  fi
# 
#  if grep -q "/home" ${ROOTFS_DIR}/etc/fstab
#  then
#    echo -e "${LTGREEN}COMMAND:${GRAY} sudo mount $(grep /home ${ROOTFS_DIR}/etc/fstab | awk '{ print $1 }') ${ROOTFS_DIR}/home${NC}"
#    sudo mount $(grep /home ${ROOTFS_DIR}/etc/fstab | awk '{ print $1 }') ${ROOTFS_DIR}/home
#  fi

  echo -e "${LTGREEN}COMMAND:${GRAY} sudo mount --bind /dev ${ROOTFS_DIR}/dev${NC}"
  sudo mount --bind /dev ${ROOTFS_DIR}/dev

  echo -e "${LTGREEN}COMMAND:${GRAY} sudo mount --bind /proc ${ROOTFS_DIR}/proc${NC}"
  sudo mount --bind /proc ${ROOTFS_DIR}/proc

  echo -e "${LTGREEN}COMMAND:${GRAY} sudo mount --bind /sys ${ROOTFS_DIR}/sys${NC}"
  sudo mount --bind /sys ${ROOTFS_DIR}/sys
else
  echo
  echo -e "${LTRED}ERROR: ${ROOTFS_DIR} could not be found. Exiting.${NC}"
  exit
fi

echo

echo -e "${LTBLUE}${ROOTFS_DIR} is now prepared for chroot ${NC}"
#echo -e "${LTBLUE}-----------------------------------------------------------------------------${NC}"
#mount | grep "${ROOTFS_DIR}"
echo
echo -e "${LTBLUE}-----------------------------------------------------------------------------${NC}"
echo -e "${LTPURPLE}You may now ${GRAY}chroot${LTPURPLE} into ${GRAY}${ROOTFS_DIR}${NC}"
echo
echo -e "${LTGREEN}COMMAND:${GRAY} chroot ${ROOTFS_DIR}${NC}"
echo
echo -e "${ORANGE}Note: When finished, exit the chroot and run:${NC}"
echo
echo -e "${LTGREEN}COMMAND:${GRAY} ${GRAY}chroot-unprep.sh ${ROOTFS_DIR}${NC}"
echo
