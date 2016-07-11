#!/bin/bash -eux

source packer/scripts/common.sh

message "Adding EPEL repo"
sudo yum install -y epel-release

# Variant #1
# wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm
# rpm -Uvh epel-release-7*.rpm
# rm -f epel-release-7*.rpm

# Variant #2
# curl -o- https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm > epel7.rpm
# sudo rpm -Uvh epel7.rpm

# Variant #3
# yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
# Install the IUS repository (optional)
# yum -y install http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-13.ius.centos7.noarch.rpm

# Enable by default:
# sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
