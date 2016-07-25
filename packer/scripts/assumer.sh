#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing Assumer"
mkdir -p /home/vagrant/toolkit && cd $_
git clone https://github.com/devsecops/assumer
chown -R vagrant.vagrant /home/vagrant/toolkit

su - vagrant -c "cd /home/vagrant/toolkit/assumer/source && gem build assumer.gemspec && gem install assumer-*.gem"

v=$(su - vagrant -c "assumer --version 2>&1 | tail -1 | cut -f2 -d\ ")
[[ $v =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] && message "Assumer version $v sucessfully installed"
