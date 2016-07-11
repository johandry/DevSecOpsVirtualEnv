#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing docker"
yum install -y docker

message "Starting docker"
service docker start

message "Enabling docker to start on reboot"
chkconfig docker on
