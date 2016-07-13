#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing Restacker"
mkdir -p /home/vagrant/toolkit && cd $_
git clone https://github.com/devsecops/restacker
chown -R vagrant.vagrant /home/vagrant/toolkit

# su - vagrant -c "cd /home/vagrant/toolkit/restacker/source && gem build restacker.gemspec"
# ERROR:
#   Invalid gemspec in [restacker.gemspec]: cannot load such file -- aws-sdk
#   ERROR:  Error loading gemspec. Aborting.

# su - vagrant -c "cd /home/vagrant/toolkit/restacker/source && gem install restacker-*.gem"
#
# v=$(su - vagrant -c "restacker --version 2>&1 | tail -1")
# [[ $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && message "Assumer version $v sucessfully installed"
