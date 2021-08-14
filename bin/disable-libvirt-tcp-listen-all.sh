#!/bin/bash

echo
echo -e "Disabling the Libvirt driver from listening for connections via TCP without authentication..."
echo -e "-------------------------------------------------------------------------"
echo -e "COMMAND: sudo sed -i 's/^listen_tcp =.*/#listen_tcp = 1/g' /etc/libvirt/libvirtd.conf"
sudo sed -i 's/^listen_tcp =.*/#listen_tcp = 1/g' /etc/libvirt/libvirtd.conf
echo -e "COMMAND: sudo sed -i 's/^auth_tcp =.*/#auth_tcp = \"none\"/g'" /etc/libvirt/libvirtd.conf
sudo sed -i 's/^auth_tcp =.*/#auth_tcp = \"none\"/g' /etc/libvirt/libvirtd.conf
echo
sudo systemctl restart libvirtd.service
echo
