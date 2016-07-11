#!/bin/bash -eux

source packer/scripts/common.sh

message "Installing Python Dependencies"
wget http://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz && \
wget http://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz
xz -d Python-2.7.11.tar.xz && \
xz -d Python-3.4.3.tar.xz
tar -xvf Python-2.7.11.tar && \
tar -xvf Python-3.4.3.tar
cd /home/vagrant/Python-2.7.11/ && ./configure && make && sudo make install
cd /home/vagrant/Python-3.4.3/ && ./configure && make && sudo make install

message "Installing pip"
cd /home/vagrant/
sudo yum install -y python-pip
sudo pip install --upgrade pip

message "Installing AWS CLI"
sudo pip install awscli
