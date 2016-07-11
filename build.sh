#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

export PACKER_CACHE_DIR=packer/packer_cache

mkdir -p ${SCRIPT_DIR}/Trash

[[ -f ${SCRIPT_DIR}/vagrant/boxes/centos7.box ]] && \
  echo "Moving old centos7.box to Trash" && \
  mv ${SCRIPT_DIR}/vagrant/boxes/centos7.box ${SCRIPT_DIR}/Trash

vagrant box list | grep -q devsecops/centos7 && \
  echo "Removing old box from Vagrant" && \
  vagrant box remove devsecops/centos7

echo "Building CentOS 7 box with Packer"
packer build ${SCRIPT_DIR}/packer/centos7.json

echo "Adding new box to Vagrant"
vagrant box add devsecops/centos7 ${SCRIPT_DIR}/vagrant/boxes/centos7.box

vagrant box list | grep -q devsecops/centos7 && \
  echo "The CentOS 7 box for DevSecOps is ready to use: " && \
  echo "  vagrant up" && \
  echo "  vagrant status" && \
