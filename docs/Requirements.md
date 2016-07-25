# Requirements

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

To use __Docker__ go to https://www.docker.com/products/docker and download the installer for your operative system then follow the instructions for [macOS](https://docs.docker.com/docker-for-mac/) or [Windows](https://docs.docker.com/docker-for-windows/). But again, if you are on macOS it can be done with Homebrew Cask (not recommended at this time _July 2016_).

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
