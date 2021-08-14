#!/bin/bash

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

convert_br_to_eth() {
  #-----------------------------------------------------------------------------
  if ! [ -z $1 ]
  then
    BRIDGE_NAME=$1
  else
    local BRIDGE_NAME=$(sudo yast lan show id=$(sudo yast lan list 2>&1 > /dev/null | grep "^[0-9]" | grep -iv "not configured" | grep -i "network bridge" | awk '{ print $1 }' | head -n 1) 2>&1 > /dev/null | grep -i "network bridgedevice name" | awk '{ print $4 }')
  fi

  if ! [ -z $2 ]
  then
    DEV_NAME=$2
  else
    local DEV_NAME=$(grep BRIDGE_PORTS /etc/sysconfig/network/ifcfg-${BRIDGE_NAME} | cut -d = -f 2 | sed "s/'//g")
  fi

  local BOOTPROTO=$(grep BOOTPROTO /etc/sysconfig/network/ifcfg-${BRIDGE_NAME} | cut -d = -f 2 | sed "s/'//g")
  local IP_ADDR=$(grep IPADDR /etc/sysconfig/network/ifcfg-${BRIDGE_NAME} | cut -d = -f 2 | sed "s/'//g")
  local NET_MASK=$(grep NETMASK /etc/sysconfig/network/ifcfg-${BRIDGE_NAME} | cut -d = -f 2 | sed "s/'//g")
  local TMP_FILE="/tmp/ifcfg-${DEV_NAME}"
  local IFCFG_FILE="/etc/sysconfig/network/ifcfg-${DEV_NAME}"

  #-----------------------------------------------------------------------------

  if [ -e ${IFCFG_FILE} ]
  then
    echo -e "${LTRED}WARNING: An ifcfg- file with that name already exists: $(basename ${IFCFG_FILE})${NC}"
    echo -e "${LTRED}         It will be overwritten.${NC}"
  fi
    #echo -e "${LTBLUE}Writing out:${LTGRAY} ${IFCFG_FILE}${NC}"
    #
    #echo "BOOTPROTO='${BOOTPROTO}'" >> ${TMP_FILE}
    #echo "BROADCAST=''" >> ${TMP_FILE}
    #echo "ETHTOOL_OPTIONS=''" >> ${TMP_FILE}
    #echo "IPADDR='${IP_ADDR}'" >> ${TMP_FILE}
    #echo "NETMASK='${NET_MASK}'" >> ${TMP_FILE}
    #echo "MTU=''" >> ${TMP_FILE}
    #echo "NAME=''" >> ${TMP_FILE}
    #echo "REMOTE_IPADDR=''" >> ${TMP_FILE}
    #echo "STARTMODE='auto'" >> ${TMP_FILE}
    #sudo mv ${TMP_FILE} ${IFCFG_FILE}

  echo -e "${LTBLUE}Converting:${LTGRAY} ${BRIDGE_NAME} -> ${DEV_NAME}${NC}"
  cd /etc/sysconfig/network
  cp ifcfg-${BRIDGE_NAME} ${TMP_FILE}
  sed -i "s/^BRIDGE.*//g" ${TMP_FILE}
  sudo mv ${TMP_FILE} ${IFCFG_FILE}

  echo -e "${LTBLUE}Stopping:${LTGRAY} ${BRIDGE_NAME}${NC}"
  sudo /sbin/ifdown ${BRIDGE_NAME}

  sudo mv ifcfg-${BRIDGE_NAME} orig.ifcfg-${BRIDGE_NAME}
 
  echo -e "${LTBLUE}Starting:${LTGRAY} ${DEV_NAME}${NC}"
  sudo /sbin/ifup ${DEV_NAME}
}

##############################################################################

convert_br_to_eth $*
