#!/bin/bash

if [ $(wc -l /etc/issue | awk '{ print $1 }') -gt 1 ]
then
  BASIC_MESSAGE="$(head -n 1 /etc/issue)"
fi

if ! [ -e /etc/issue.orig ]
then
  sudo mv /etc/issue /etc/issue.orig
fi

if ! [ -z ${BASIC_MESSAHE} ]
then
  echo "${BASIC_MESSAGE}" > /tmp/issue
  sudo mv /tmp/issue /etc/issue
fi
