#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Configuring sshd_config options"

message "Turning off sshd DNS lookup to prevent timeout delay"
echo "UseDNS no" >> /etc/ssh/sshd_config

message "Disablng GSSAPI authentication to prevent timeout delay"
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
