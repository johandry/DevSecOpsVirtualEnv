#!/bin/bash -eux

source packer/scripts/common.sh

message "Removing packages for the kernel"
if rpm -q --whatprovides kernel | grep -Fqv $(uname -r); then
  rpm -q --whatprovides kernel | grep -Fv $(uname -r) | xargs yum -y remove
fi

message "Cleaning up yum cache of metadata and packages to save space"
yum -y remove kernel-devel kernel-headers
yum -y update
yum -y clean all
yum --enablerepo=epel clean all

message "Cleaning up the yum history and logs"
yum history new
truncate -c -s 0 /var/log/yum.log

message "Removing temporary files used to build box"
rm -rf /tmp/*

message "Remove Virtualbox specific files"
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*
rm -rf *.iso *.iso.? /tmp/vbox /home/vagrant/.vbox_version

message "Cleanup log files"
find /var/log -type f | while read f; do echo -ne '' > $f; done;
