
# DevSecOpsVirtualEnv
---

DevSecOpsVirtualEnv is a tool to build a virtual environment for the [DevSecOps Bootcamp](https://github.com/devsecops/bootcamp). This virtual environment is up to date, with all the software and tools required for such bootcamp or DevSecOps activities, and to be used with different platforms such as Vagrant, Docker or AWS.

## Table of Content

- [Problem & Solution](#problem_&_solution)
- [Requirements](#requirements)
- [Installation](#installation)
- [Build an Environment for Vagrant](#build-a-environment-for-virtualbox-with-vagrant)
- [Build a Environment for Docker](#build-a-environment-for-docker)
- [Use the Vagrant Environment](#use-the-vagrant-environment)
- [Use the Docker Environment](#use-the-docker-environment)
- [TODO](#todo)

## Problem & Solution

During the DevSecOps Bootcamp the students create a virtual machine using Vagrant. Every time the machine need to be provisioned it takes around 30 minutes, time that could be invested in learning. As a side effect, if the machine is destroyed, those installed software and tools disappear and have to be installed again.

To avoid these delays DevSecOps Virtual Environment build an up to date environment with all the required software and tools from the DevSecOps Toolkit. This environment will be created by instructor before the training whenever there is an update (weekly or monthly). This environment also give us the option to use other platforms such as Docker or AWS besides Vagrant.

## Requirements

In Windows or macOS download the installer for your operative system and architecture. In macOS you can use Homebrew as a CLI alternative.

[Homebrew](http://brew.sh/): Optional and just in macOS

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew --version
```

[Packer](https://www.packer.io/downloads.html)

```bash
brew install packer
packer --version
```

[Vagrant](https://www.vagrantup.com/downloads.html)

```bash
brew cask install virtualbox
brew cask install vagrant
vagrant --version

brew cask install vagrant-manager    # Optional
```

[Docker](https://www.docker.com/products/docker)

```bash
brew cask install dockertoolbox      # Recommended manual installation instead of Homebrew
docker --version
```

To know more about the requirements, go to [docs/Requirements.md](docs/Requirements.md)

## Installation

Just clone the repository

```bash
git clone https://github.com/johandry/DevSecOpsVirtualEnv.git DevSecOpsVirtualEnv && cd $_
```

## Build a Environment for VirtualBox with Vagrant

To build it, use the parameter `--vagrant`, or nothing, as it is the default option.

    ./build.sh

This process will take a while, around __2 hours__ depending of your internet bandwidth, so be patience. To know more about the build for Vagrant, go to [docs/Vagrant_Build.md](docs/Vagrant_Build.md).

## Build a Environment for Docker

It is important to know that it is not needed to build an image because [DockerHub](https://hub.docker.com/) will do it automatically every time the `Dockerfile` change in this GitHub repository.

To build the image for Docker execute the `build.sh` script with the parameter `--docker`, like this:

    ./build.sh --docker

The docker build takes around 15 minutes depending of your internet bandwidth. To know more about the build for Docker, go to [docs/Docker_Build.md](docs/Docker_Build.md)

## Use the Vagrant Environment

To use the box:

    vagrant init johandry/DevSecOps_CentOS_7
    vagrant up
    vagrant ssh

Or, copy the `Vagrantfile` in the repository to your own directory and create a `workspace` directory.

```bash
mkdir DevSecOps && cd $_
curl -o Vagrantfile https://raw.githubusercontent.com/johandry/DevSecOpsVirtualEnv/master/Vagrantfile
mkdir workspace
vagrant up
vagrant ssh
```

## Use the Docker Environment

The docker build is way more faster than the vagrant build and it - automatically - upload the image to Docker Hub, something that - at this time - have to be done manually with the vagrant build.

Once the image is created, the script will upload it to DockerHub. Now you can pull it, check it and run it. When it is not needed, you may delete the container and image.

```bash
mkdir DevSecOps && cd $_
mkdir workspace
docker run -it --rm --name devsecops -v ${PWD}/workspace:/root/workspace johandry/devsecops
```

The parameter `-v ${pwd}/workspace:/root/workspace` can be avoided if you share the directory using the __File Sharing__ tab in the Docker Preferences. Read the instructions in [docs/Docker_Build.md](docs/Docker_Build.md).

## What's included in the environment?

The environment builded contain:
* CentOS 7 (1511)
* Ruby 2.3.1
* rbenv
* Python 2.7.11
* Python 3.4.3
* Pip
* AWS CLI
* PostgreSQL
* SQLite
* NodeJS
* DevSecOps Toolkit
  * Assumer
  * Selfie
  * Restacker
* PenTest Toolkit
  * Nmap
  * Metasploit
* Main Gems: Rails, Bundler, Thor
* Useful Packages: Git, Perl, Vim, curl, wget, Links, Lynx & EPEL Repo

The Vagrant box also include (not included in Docker image):
* Docker
* MariaDB

MariaDB is not installed with Docker because if needed it is better to run a MariaDB container (i.e from [here](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/mariadb/centos7)) and link them.

## TODO


- [ ] Make the Paker file publish the box to Vagrant Cloud. It could be done by uploading the box or just the URL of the box previously uploaded to another location.
- [X] The Gems Restacker and Selfie are failing the build because aws-sdk cannot be loaded.
- [X] Improve the Dockerfile.
- [X] Set a VOLUME in the Dockerfile to sync a folder
- [ ] Do the AWS provider with Vagrant
- [X] Add metasploit to CentOS
- [X] What other DevSecOps tools or software is required?: None, so far
- [ ] Try Packer build the docker image, instead of using a Dockerfile. Or both.
- [ ] Add Rspec testing
- [ ] Create a demo and publish it on Youtube
