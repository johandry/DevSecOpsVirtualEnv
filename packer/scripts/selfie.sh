#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing Selfie"
mkdir -p /home/vagrant/toolkit && cd $_
git clone https://github.com/devsecops/selfie
chown -R vagrant.vagrant /home/vagrant/toolkit

su - vagrant -c "cd /home/vagrant/toolkit/selfie && bundle && gem build selfie.gemspec && gem install selfie-*.gem"

v=$(su - vagrant -c "selfie --version 2>&1 | tail -1")
[[ $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && message "Selfie version $v sucessfully installed"
