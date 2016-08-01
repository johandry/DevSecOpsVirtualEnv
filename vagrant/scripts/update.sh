#!/bin/bash

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Updating packages"
sudo yum update -y

message "If the update took a lot of time, then it is time to rebuild the box with Packer. Execute ./build.sh"
