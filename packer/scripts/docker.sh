#!/bin/bash -eux

source packer/scripts/common.sh

message "Installing docker"
yum install -y docker

message "Starting docker"
service docker start

message "Enabling docker to start on reboot"
chkconfig docker on
