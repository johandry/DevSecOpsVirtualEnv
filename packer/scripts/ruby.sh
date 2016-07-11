#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }


message "Installing Ruby Dependencies"
sudo yum groupinstall "Development Tools" -y
sudo yum install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev openssl-devel readline-devel zlib-devel

message "Installing rbenv"
git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile

message "rbenv Init"
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile
source /home/vagrant/.bash_profile

message "Installing ruby-build"
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv rehash

message "Disable Ruby Docs"
echo "gem: --no-document" >> /home/vagrant/.gemrc
rbenv install 2.3.1
rbenv global 2.3.1
