
# DevSecOpsVirtualEnv

This is a tool to build a virtual environment for the [DevSecOps Bootcamp](https://github.com/devsecops/bootcamp), up to date and with all the software and tools required for such bootcamp. Also to be used with different platforms such as Vagrant, Docker or AWS.

During the DevSecOps Bootcamp the students create a virtual machine using Vagrant with some of the packages and software required. Eventually other tools from the DevSecOps Toolkit are added to the machine. Every time the machine need to be provisioned it takes a lot of time, time that could be invested in learning, also those installed software and tools disappear and have to be installed again. To avoid these delays DevSecOpsVirtualEnv builded an up to date environment with all the required software and tools from the DevSecOps Toolkit. It also give the option to use other platforms such as Docker or AWS.

## Table of Content

- [Requirements](#requirements)
- [Installation](#installation)
- [Build an Environment](#build-an-environment)
  - [Vagrant](#vagrant)
  - [Docker](#docker)
  - [AWS](#aws)
- [TODO](#todo)

## Requirements
---

If you are on macOS it is recommended, but not required, to install [Homebrew](http://brew.sh/), it will help you to install everything from the command line.

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

[Packer](https://www.packer.io/) is required to build the vagrant box or the AMI. Download the installer for your operative system and architecture from https://www.packer.io/downloads.html or use Homebrew to install it (just on macOS).

        brew install packer

Depending of the DevSecOps environment platform you feel more comfortable you need to install [Vagrant](https://www.vagrantup.com/) or [Docker](https://www.docker.com/).

To use __Vagrant__ go to https://www.vagrantup.com/downloads.html and download the installer for your operative system and architecture.

If you are on macOS it can be installed with Homebrew Cask. You need to install VirtualBox then Vagrant, and (optional) [Vagrant Manager](http://vagrantmanager.com/) to manage the virtual machines from a GUI instead of CLI.

    brew cask install virtualbox
    brew cask install vagrant
    brew cask install vagrant-manager

To test it, check the version and create a VM with CentOS or whatever Linux you like.

    packer --version
    vagrant --version
    mkdir -p ~/Sandbox/Vagrant && cd $_
    vagrant init centos/7
    vagrant up
    vagrant ssh
    vagrant halt
    vagrant destroy

For more information go to https://www.vagrantup.com/docs/

To use __Docker__ go to https://www.docker.com/products/docker and download the installer for your operative system. But again, if you are on macOS it can be done with Homebrew Cask.

    brew cask install dockertoolbox

To test it, check the version, run an image with Nginx, run another with centos, list all the containers, delete them all and delete all the images.

    docker --version
    docker run -d -p 80:80 --name webserver nginx
    open http://localhost/  # Or, In a browser, go to http://localhost/
    docker run -it centos
    docker ps -a
    docker rm $(docker ps -a -q)
    docker images
    docker rmi $(docker images -a -q)

For more information go to https://docs.docker.com/

## Installation
---

Just clone the repository

    git clone https://github.com/johandry/DevSecOpsVirtualEnv.git DevSecOpsVirtualEnv && cd $_

## Build an Environment
---

The environment can be builded for different platforms using the script `build.sh`.

### Vagrant

To build it, use the parameter `--vagrant`, or nothing, it is the default option.

    ./build.sh --vagrant

This process will take a while, so be patience.

The build script will destroy the virtual machine running, remove the previous box created and create the new box using Packer. Once the box is ready you can use the box file or publish it on [Vagrant Cloud](https://atlas.hashicorp.com/vagrant) so others - students - can use it.

To use the box from the __filesystem__ (the created file), the `build.sh` script will do it for you if you export the variable `BOX_LOCAL` set to 1.

    export BOX_LOCAL=1
    ./build.sh --vagrant

To use the box from __Vagrant Cloud__ so everybody (i.e. Bootcamp students) can use it, just execute the `build.sh` script or export the variable `BOX_LOCAL` set to 0 (default value) before execute it.

    export BOX_LOCAL=0  
    ./build.sh --vagrant

To make it available, it have to be uploaded first. _This process can and will be automated_.
  1. Go to https://atlas.hashicorp.com/vagrant and login.
  1. Go to the box __DevSecOps_CentOS_7__.
  1. Create a new version going to __New Version__ at the left menu.
  1. Enter the version number. Make sure it is compatible with [RubyGems versioning](http://guides.rubygems.org/patterns/#semantic-versioning).
  1. Enter the description. You can use the description of the previous version and add what is new.
  1. Click on __Create new provider__.
  1. Select the provider __VirtualBox__ and __Upload__. Click on __Continue to upload__.
  1. Choose the created file located in the directory `vagrant/boxes`.
  1. Click on Finish and go to Versions.
  1. Click on the __unreleased link__ then in __Release version__ button.

In both cases the box name is __johandry/DevSecOps_CentOS_7__. To change it, modify the `Vagrantfile` in the line

    config.vm.box = "johandry/DevSecOps_CentOS_7"

The first field (`johandry`) is the Vagrant Cloud username and the second field (`DevSecOps_CentOS_7`) is the box name.

To use the box, use the `Vagrantfile` in the repository, use the variable `config.vm.box` in a custom Vagrantfile or with:

    vagrant init johandry/DevSecOps_CentOS_7
    vagrant up
    vagrant ssh

### Docker

__NOTE__: It is important to know that it is not needed to build an image because [DockerHub](https://hub.docker.com/) will do it automatically every time the `Dockerfile` change in this GitHub repository.

To build the image for Docker execute the `build.sh` script with the parameter `--docker`, like this:

    ./build.sh --docker

Once the image is created, the script will upload it to DockerHub. Now you can pull it, check it and run it. When it is not needed, you may delete the container and image.

    docker pull johandry/devsecops    # Unnecessary if was recently builded
    docker images
    docker run -it johandry/devsecops

    docker rm $(docker ps -a | grep johandry/devsecops | cut -f1 -d\ )
    docker rmi johandry/devsecops

If the image is already in DockerHub, just need to run it.

    docker run -it johandry/devsecops

### AWS

Ups! This is not done yet.

The idea is to create an AMI using Vagrant and publish it to AWS. It will provide the same advantages as if the VM is running on VirtualBox but instead will be an instance in your AWS account.

## TODO
---

- [ ] Make the Paker file publish the box to Vagrant Cloud. It could be done by uploading the box or just the URL of the box previously uploaded to another location.
- [ ] The Gems Restacker and Selfie are failing the build because aws-sdk cannot be loaded.
- [ ] Improve the Dockerfile, some commands may not be executed as RUN, instead can be external scripts. Like with Packer or Vagrant
- [ ] Set a VOLUME in the Dockerfile to sync a folder
- [ ] Do the AWS provider with Vagrant
- [ ] Do Vagrant multi-machine to create a Kali VM for the meta-exploits labs. Or, install meta-exploits in this machine.
- [ ] What other DevSecOps tools or software is required?
- [ ] Would we add other provided? OpenStak?
- [ ] Would we use Docker as provider in Vagrant or just use docker?
- [ ] Try Packer build the docker image, instead of using a Dockerfile. Or both.
- [ ] Add Rspec testing
