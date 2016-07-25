#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

RUBY_VER=2.3.1

message "Installing Ruby Dependencies"
# sudo yum groupinstall "Development Tools" -y
# sudo yum install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev openssl-devel readline-devel zlib-devel
sudo yum install -y autoconf bison openssl-devel readline-devel zlib-devel

message "Installing rbenv"
git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
chown -R vagrant.vagrant /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile
export PATH="/home/vagrant/.rbenv/bin:$PATH"

message "rbenv Init"
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile
chown -R vagrant.vagrant /home/vagrant/.bash_profile
su - vagrant -c 'export PATH="/home/vagrant/.rbenv/bin:$PATH"; eval "$(rbenv init -)"'

message "Installing ruby-build"
git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
chown -R vagrant.vagrant /home/vagrant/.rbenv/plugins/ruby-build
rbenv rehash

message "Disable Ruby Docs"
echo -ne "install: --no-document\nupdate: --no-document\ngem: --no-document" >> /home/vagrant/.gemrc
chown vagrant.vagrant /home/vagrant/.gemrc
su - vagrant -c "rbenv install $RUBY_VER"
su - vagrant -c "rbenv global $RUBY_VER"

message "Installing Rails"
su - vagrant -c "gem install rails"
