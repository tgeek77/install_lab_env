#!/bin/bash

PXELINUX="/usr/share/syslinux/pxelinux.0"
VESAMENU="/usr/share/syslinux/vesamenu.c32"
TFTPBOOT="/srv/tftpboot"

echo "-----------------------------------------------------------------------"
echo "             Configuring Lab Machine as a Lab Server"
echo "-----------------------------------------------------------------------"
echo

echo "Configuring NTP ..." 
sudo cp /etc/ntp.conf /tmp
sudo chown $USER /tmp/ntp.conf
sudo chmod +w /tmp/ntp.conf
echo "server 127.127.1.0" >> /tmp/ntp.conf
echo "fudge 127.127.1.0 stratum 10" >> /tmp/ntp.conf
sudo mv /tmp/ntp.conf /etc/
sudo chown root.ntp /etc/ntp.conf
sudo chmod 640 /etc/ntp.conf
sudo systemctl enable ntpd
sudo systemctl start ntpd
echo

echo "Configuring NFS Server ..." 
cp /etc/exports /tmp
echo "/install	*(ro,no_root_squash,sync,no_subtree_check)" >> /tmp/exports
sudo mv /tmp/exports /etc
sudo chown root.root /etc/exports
sudo systemctl enable nfsserver
sudo systemctl start nfsserver
echo

echo "Configuring TFTP/PXE ..."
sudo cp ${PXELINUX} ${TFTPBOOT}
sudo cp ${VESAMENU} ${TFTPBOOT}
sudo sed -i '/.*disable.*/d' /etc/xinetd.d/tftp
sudo /usr/sbin/rcxinetd restart
echo

echo "Configuring DHCP ..."
if ! [ -e /var/lib/doaway/maclist ]
then
  TOUCH_MACLIST=yes
  sudo touch /var/lib/doaway/maclist
fi
/usr/bin/build-dhcp-config >> /tmp/dhcpd.conf
sudo mv /tmp/dhcpd.conf /etc
sudo chown root.root /etc/dhcpd.conf
if [ -z ${TOUCH_MACLIST} ]
then
  sudo rm -f /var/lib/doaway/maclist
fi
echo "  Next Steps:"
echo "    -Configure a static IP address"
echo "    -Run YaST DHCP Server module"
echo
