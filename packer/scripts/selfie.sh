#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing Selfie"
mkdir -p /home/vagrant/toolkit && cd $_
git clone https://github.com/devsecops/selfie
chown -R vagrant.vagrant /home/vagrant/toolkit

# su - vagrant -c "cd /home/vagrant/toolkit/selfie && gem build selfie.gemspec"
# ERROR:
#   Invalid gemspec in [selfie.gemspec]: cannot load such file -- aws-sdk
#   ERROR:  Error loading gemspec. Aborting.

# su - vagrant -c "cd /home/vagrant/toolkit/selfie && gem install selfie-*.gem"
#
# v=$(su - vagrant -c "selfie --version 2>&1 | tail -1")
# [[ $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && message "Selfie version $v sucessfully installed"
