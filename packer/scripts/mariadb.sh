#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing MariaDB"
sudo yum -y install mariadb mariadb-server mariadb-devel
sudo yum -y install links nodejs

message "Start MariaDB service and enable on boot"
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service
