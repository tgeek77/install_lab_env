#!/bin/bash
# version: 1.0.2
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

##############################################################################
#                           Main Code Body
##############################################################################

echo -e "${LTBLUE}==============================================================${NC}"
echo -e "${LTBLUE} Unmounting /rescue ${NC}"
echo -e "${LTBLUE}==============================================================${NC}"

if [ -d /rescue ]
then
  echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R /rescue/dev${NC}"
  sudo umount -R /rescue/dev

  echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R /rescue/proc${NC}"
  sudo umount -R /rescue/proc

  echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R /rescue/sys${NC}"
  sudo umount -R /rescue/sys

  if grep -q /home /rescue/etc/fstab
  then
    echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R /rescue/home${NC}"
    sudo umount -R /rescue/home
  fi

  if grep -q /boot/efi /rescue/etc/fstab
  then
    echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R /rescue/boot/efi${NC}"
    sudo umount -R /rescue/boot/efi
  fi

  echo -e "${LTGREEN}COMMAND:${GRAY} sudo umount -R /rescue${NC}"
  sudo umount -R /rescue
 
  echo
else
  echo -e "${LTBLUE}/rescue doesn't seem to be mounted. Exiting.${NC}"
  echo
fi

if [ -d /rescue ]
then
  echo -e "${LTGREEN}COMMAND:${GRAY} sudo rm -rf /rescue${NC}"
  sudo rm -rf /rescue
  echo
fi

echo
