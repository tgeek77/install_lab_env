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

configure_new_bridge() {
  if [ -z $1 ]
  then
    echo
    echo -e "${LTRED}ERROR: Missing bridge name or node number.${NC}"
    echo
    echo -e "${GRAY}USAGE: $0 <bridge-name> <node_number> <bridge_network>${NC}"
    echo
    exit 1
  elif [ -z $2 ]
  then
    echo
    echo -e "${LTRED}ERROR: Missing node number.${NC}"
    echo -e "${LTRED}       The node number must be a number between 1 and 9.${NC}"
    echo
    echo -e "${GRAY}USAGE: $0 <bridge-name> <node_number> <bridge_network>${GRAY}"
    echo
    exit 1
  elif ! echo $2 | grep -q [1-9]
  then
    echo
    echo -e "${LTRED}ERROR: The node number must be a number between 1 and 9.${NC}"
    echo
    exit 1
  elif [ -z $3 ]
  then
    echo
    echo -e "${LTRED}ERROR: The Bridge network must be the network ID of the bridge with CIDR mask.${NC}"
    echo -e "${GRAY}       Example: 192.168.124.0/24${NC}"
    echo
    echo -e "${GRAY}USAGE: $0 <bridge-name> <node_number> <bridge_network>${NC}"
    echo
    exit 1
  else
    BRIDGE_NAME=$1
    NODE_NUM=$2
    BRIDGE_NETWORK=$3
  fi

  #-----------------------------------------------------------------------------

  TMP_FILE="/tmp/ifcfg-${BRIDGE_NAME}"
  IFCFG_FILE="/etc/sysconfig/network/ifcfg-${BRIDGE_NAME}"
  IP_NETWORK="$(echo ${BRIDGE_NETWORK} | cut -d / -f 1 | cut -d . -f 1,2,3)"
  IP_ADDR="${IP_NETWORK}.${NODE_NUM}"
  CIDRMASK="/$(echo ${BRIDGE_NETWORK} | cut -d / -f 2)"
  DEV_NAME=$(yast lan show id=$(yast lan list 2>&1 > /dev/null | grep "^[0-9]" | grep -i "not configured" | grep -i ethernet | awk '{ print $1 }' | head -n 1 ) 2>&1 > /dev/null | grep "Device Name" | awk '{ print $3 }')
  #DEV_NAME=$(yast lan show id=$(yast lan list 2>&1 > /dev/null | grep "^[0-9]" | grep -i ethernet | awk '{ print $1 }' | head -n 2 | tail -n 1) 2>&1 > /dev/null | grep "Device Name" | awk '{ print $3 }')
  BOOTPROTO="static"

  #-----------------------------------------------------------------------------

  if [ -e ${IFCFG_FILE} ]
  then
    echo
    echo -e "${LTRED}ERROR: An ifcfg- file with that name already exists:${GRAY} $(basename ${IFCFG_FILE})${NC}"
    echo
    exit 1
  elif [ -x ${DEV_NAME} ]
  then
    echo
    echo -e "${LTRED}ERROR: No unconfigured ethernet device available.${NC}"
    echo
    exit 1
  else
    echo
    echo -e "${LTPURPLE}Bridge name:${GRAY} ${BRIDGE_NAME}${NC}"
    echo -e "${LTPURPLE}Using device:${GRAY} ${DEV_NAME}${NC}"
    echo -e "${LTPURPLE}Writing out:${GRAY} ${IFCFG_FILE}${NC}"
    echo

    echo "BOOTPROTO='${BOOTPROTO}'" >> ${TMP_FILE}
    echo "BRIDGE='yes'" >> ${TMP_FILE}
    echo "BRIDGE_FORWARDDELAY='0'" >> ${TMP_FILE}
    echo "BRIDGE_PORTS='${DEV_NAME}'" >> ${TMP_FILE}
    echo "BRIDGE_STP='off'" >> ${TMP_FILE}
    echo "BROADCAST=''" >> ${TMP_FILE}
    echo "ETHTOOL_OPTIONS=''" >> ${TMP_FILE}
    echo "IPADDR='${IP_ADDR}${CIDRMASK}'" >> ${TMP_FILE}
    echo "MTU=''" >> ${TMP_FILE}
    echo "REMOTE_IPADDR=''" >> ${TMP_FILE}
    echo "STARTMODE='auto'" >> ${TMP_FILE}

    mv ${TMP_FILE} ${IFCFG_FILE}
  fi

  echo -e "${LTBLUE}Starting:${LTGRAY} ${BRIDGE_NAME}${NC}"
  sudo /sbin/ifup ${BRIDGE_NAME}
}

#############################################################################

configure_new_bridge $*
