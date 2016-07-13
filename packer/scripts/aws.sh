#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing Python 2.7 & 3.4"
wget http://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
wget http://www.python.org/ftp/python/3.4.3/Python-3.4.3.tar.xz

tar xf Python-2.7.11.tar.xz
tar xf Python-3.4.3.tar.xz

cd /home/vagrant/Python-2.7.11/ && ./configure && make && sudo make install
cd /home/vagrant/Python-3.4.3/ && ./configure && make && sudo make install

rm -rf /home/vagrant/Python-2.7.11*
rm -rf /home/vagrant/Python-3.4.3*

message "Installing pip"
cd /home/vagrant/
sudo yum install -y python-pip
sudo pip install --upgrade pip

message "Installing AWS CLI"
sudo pip install awscli
