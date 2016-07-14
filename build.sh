#!/bin/bash

# Vagrant Settings
BOX_FILE=CentOS-7-x86_64
BOX_LOCAL=${BOX_LOCAL:-0}
VAGRANT_CLOUD='https://atlas.hashicorp.com'

# Docker Settings
IMG_NAME='johandry/devsecops'

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

vagrant_build() {
  [[ -z $(vagrant --version 2>/dev/null) ]] && \
    echo -ne "\x1B[91;1m[ ERROR ]\x1B[0m\x1B[93;1m  Vagrant\x1B[0m not found\n" && \
    exit 1

  location='to use it locally'
  [[ $BOX_LOCAL -eq 0 ]] && location='to use it from Vagrant Cloud'
  echo -e "\033[93;1mBuilding the environment for Vagrant $location\033[0m"

  # Get the box name defined in the Vagrantfile
  BOX_NAME=$(grep '^  config.vm.box =' Vagrantfile | sed 's/.*= "\(.*\)"/\1/')
  box=(${BOX_NAME//\// }) # box = [ account_name, box_name ]
  VAGRANT_CLOUD="${VAGRANT_CLOUD}/${box[0]}/boxes/${box[1]}"

  export PACKER_CACHE_DIR=packer/packer_cache

  vagrant status | grep -q 'running (virtualbox)' && \
    echo "Destroying the running VMs" && \
    vagrant destroy -f

  [[ -f ${SCRIPT_DIR}/vagrant/boxes/${BOX_FILE}.box ]] && \
    echo "Removing old ${BOX_FILE}.box" && \
    rm ${SCRIPT_DIR}/vagrant/boxes/${BOX_FILE}.box

  vagrant box list | grep -q "${BOX_NAME}" && \
    echo "Removing old box ${BOX_NAME} from Vagrant" && \
    vagrant box remove ${BOX_NAME}

  mkdir -p ${SCRIPT_DIR}/vagrant/boxes

  echo "Building CentOS 7 box with Packer"
  packer build ${SCRIPT_DIR}/packer/centos7.json

  if [[ $BOX_LOCAL -eq 1 ]]; then
    [[ -f ${SCRIPT_DIR}/vagrant/boxes/${BOX_FILE}.box ]] && \
      echo "Adding new box to Vagrant" && \
      vagrant box add ${BOX_NAME} ${SCRIPT_DIR}/vagrant/boxes/${BOX_FILE}.box

      vagrant box list | grep -q "${BOX_NAME}" && \
        echo -e "\033[93;1mThe new CentOS 7 box for DevSecOps is ready to use:\033[0m" && \
        echo "  vagrant up" && \
        echo "  vagrant status" && \
        echo "  vagrant ssh" && \
        echo -e "\033[93;1mAnd to be destroyed:\033[0m" && \
        echo "  vagrant destroy" && \
        echo
  else
    echo -e "\033[93;1mUpdate/upload the box to Vagrant Cloud\033[0m"
    echo "  Follow the process in the README.md and upload the file ${SCRIPT_DIR}/vagrant/boxes/${BOX_FILE}.box"
    echo
  fi
}

docker_build(){
  [[ -z $(docker --version 2>/dev/null) ]] && \
    echo -ne "\x1B[91;1m[ ERROR ]\x1B[0m\x1B[93;1m  Docker\x1B[0m not found\n" && \
    exit 1

  dkr_username=$(echo ${IMG_NAME} | cut -f1 -d'/')
  echo -e "\033[93;1mLogin to DockerHub as ${dkr_username}\033[0m"
  docker login -u ${dkr_username}

  docker build -t ${IMG_NAME} .
  docker push ${IMG_NAME}

  docker images | grep -q johandry/devsecops && \
    echo -e "\033[93;1mThe new CentOS 7 image for DevSecOps is ready to use:\033[0m" && \
    echo "  docker images" && \
    echo "  docker run -it ${IMG_NAME}" && \
    echo "And to be destroyed:" && \
    echo "  docker rmi ${IMG_NAME}" && \
    echo
}

aws_build(){
  echo "Wait, it is not completed yet!"
}

[[ -z $(packer --version 2>/dev/null) ]] && \
  echo -ne "\x1B[91;1m[ ERROR ]\x1B[0m\x1B[93;1m  Packer\x1B[0m not found\n" && \
  exit 1

builder=vagrant_build
[[ "$1" -eq "--vagrant" ]] && builder=vagrant_build
[[ "$1" -eq "--docker"  ]] && builder=docker_build
[[ "$1" -eq "--aws"     ]] && builder=aws_build
eval "${builder}"
