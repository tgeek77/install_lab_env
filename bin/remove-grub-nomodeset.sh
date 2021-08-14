#!/bin/bash

GRUB_CONFIG_LIST="
/boot/grub2/grub.cfg 
/etc/sysconfig/bootloader 
/etc/default/grub
"

echo
echo "Removing \"nomodeset\" from all GRUB config files"
echo

for FILE in ${GRUB_CONF_FILES}
do
  sudo sed -i 's/nomodeset//g' ${FILE}
done

echo
echo "----- finished -----"
echo
echo "You will need to reboot for this to take effect."
echo
