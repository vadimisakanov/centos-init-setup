#!/bin/bash

# script gets server ready for docker deployments with the fresh kernel
# steps:
# - disables selinux
# - setups kernel-ml (4.x)
# - sets 4.x kernel as default
# - reboots
# run in screen

sed -i "s/SELINUX=permissive/SELINUX=disabled/g" /etc/selinux/config
setenforce 0

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm 
yum --enablerepo=elrepo-kernel -y install kernel-ml
yum --enablerepo=elrepo-kernel -y swap kernel-headers -- kernel-ml-headers
yum --enablerepo=elrepo-kernel -y swap kernel-tools-libs -- kernel-ml-tools-libs
yum --enablerepo=elrepo-kernel -y install kernel-ml kernel-ml-devel kernel-ml-headers kernel-ml-tools kernel-ml-tools-libs kernel-ml-tools-libs-devel

grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg

reboot

exit 1
