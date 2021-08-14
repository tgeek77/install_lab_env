#!/bin/bash

echo
echo -e "Disabling the Libvirt-QEMU driver from listening for VNC and Spice connections on all public interfaces ..."
echo -e "-------------------------------------------------------------------------"
echo -e "COMMAND: sudo sed -i 's/^vnc_listen.*/#vnc_listen = \"0.0.0.0\"/g' /etc/libvirt/qemu.conf"
sudo sed -i 's/^vnc_listen.*/#vnc_listen = \"0.0.0.0\"/g' /etc/libvirt/qemu.conf
echo -e "COMMAND: sudo sed -i 's/^spice_listen.*/#spice_listen = \"0.0.0.0\"/g'" /etc/libvirt/qemu.conf
sudo sed -i 's/^spice_listen.*/#spice_listen = \"0.0.0.0\"/g' /etc/libvirt/qemu.conf
echo
sudo systemctl restart libvirtd.service
