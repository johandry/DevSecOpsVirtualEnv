#!/bin/bash

# Vagrant Parameters
BOX_FILE=CentOS-7-x86_64
BOX_LOCAL=${BOX_LOCAL:-0}
VAGRANT_CLOUD='https://atlas.hashicorp.com'

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

vagrant_build() {
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
    echo "  At this time this process is not automated due to the account limitations. The steps are:"
    echo "    1. Open ${VAGRANT_CLOUD}"
    echo "    2. Create a new version and enter the description"
    echo "    3. Select the provider 'VirtualBox'"
    echo "    4. Upload the file ${SCRIPT_DIR}/vagrant/boxes/${BOX_FILE}.box"
    echo "    5. Click on Finish and go to Versions"
    echo "    6. Click on the unreleased link then in 'Release Version' button"
    echo -e "\033[93;1mOnce the box is updated in Vagrant Could it will be ready to be used:\033[0m"
    echo "  vagrant init ${BOX_NAME}  # Optional, you can use the provided Vagrantfile"
    echo "  vagrant up"
    echo "  vagrant status"
    echo "  vagrant ssh"
    echo
  fi
}

docker_build(){
  IMG_NAME=$(grep '^  config.vm.box =' Vagrantfile | sed 's/.*= "\(.*\)"/\1/')

  echo "NOTE: It is not needed to build this image as DockerHub build it everytime the Dockerfile change"
  echo "      To use it:"
  echo "        docker pull ${IMG_NAME}"
  echo "        docker images"
  echo "        docker run -it ${IMG_NAME}"
  echo

  docker build -t ${IMG_NAME} .
  echo "The image is ready to use:"
  echo "  docker images"
  echo "  docker run -it ${IMG_NAME}"
  echo "And to be destroyed:"
  echo "  docker rmi ${IMG_NAME}"
  echo
}

aws_build(){
  echo "Wait, it is not completed yet!"
}

builder=vagrant_build
[[ "$1" -eq "--vagrant" ]] && builder=vagrant_build
[[ "$1" -eq "--docker"  ]] && builder=docker_build
[[ "$1" -eq "--aws"     ]] && builder=aws_build
eval "${builder}"
