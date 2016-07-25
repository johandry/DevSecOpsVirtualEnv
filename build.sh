#!/bin/bash

# Vagrant Settings
BOX_FILE=CentOS-7-x86_64
BOX_LOCAL=${BOX_LOCAL:-0}

# Docker Settings
CONTAINER_NAME='devsecops'

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
  VAGRANT_CLOUD="https://atlas.hashicorp.com/${box[0]}/boxes/${box[1]}"

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

  IMG_NAME=$(grep IMAGE_NAME ${SCRIPT_DIR}/docker/Dockerfile | cut -d\  -f3)

  dkr_username=$(echo ${IMG_NAME} | cut -f1 -d'/')
  cat  ${HOME}/.docker/config.json | tr -d '\n' | grep -q '"https://index.docker.io/.*":.*{.*"auth": ".\{1,\}"' || (
    echo -e "\033[93;1mLogin to DockerHub as ${dkr_username}\033[0m. If ${dkr_username} is not your user, press Ctrl+C and modify the Dockerfile"
    docker login -u ${dkr_username}
  )

  docker build -t ${IMG_NAME} ${SCRIPT_DIR}/docker/.
  docker push ${IMG_NAME}

  if ! docker images | grep -q ${IMG_NAME}
  then
    echo -e "\033[93;1mThe new CentOS 7 image for DevSecOps failed. It cannot be found.\033[0m"
    exit 1
  fi

  container_user=$(grep 'ENV REG_USER' ${SCRIPT_DIR}/docker/Dockerfile | cut -d\  -f3)

  docker images | grep -q ${IMG_NAME} && (
    echo -e "\033[93;1mThe new CentOS 7 image for DevSecOps is ready to use:\033[0m"
    echo "  docker images"
    echo "  docker run -it --rm --name ${CONTAINER_NAME} -v \${PWD}/workspace:/home/${container_user}/workspace ${IMG_NAME}"
    echo
  )
}

aws_build(){
  echo "Wait, it is not completed yet!"
}

[[ -z $(packer --version 2>/dev/null) ]] && \
  echo -ne "\x1B[91;1m[ ERROR ]\x1B[0m\x1B[93;1m  Packer\x1B[0m not found\n" && \
  exit 1

builder=vagrant_build
[[ "$1" == "--vagrant" ]] && builder=vagrant_build
[[ "$1" == "--docker"  ]] && builder=docker_build
[[ "$1" == "--aws"     ]] && builder=aws_build
eval "${builder}"
