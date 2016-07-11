#!/bin/bash -eux

source packer/scripts/common.sh

message "Configuring sshd_config options"

message "Turning off sshd DNS lookup to prevent timeout delay"
echo "UseDNS no" >> /etc/ssh/sshd_config

message "Disablng GSSAPI authentication to prevent timeout delay"
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
