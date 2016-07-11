#!/bin/bash -eux

message () { echo -e "\033[93;1mSCRIPT:\033[0m ${1}"; }

message "Installing Vagrant SSH key"
install -v -o vagrant -g vagrant -m 0700 -d /home/vagrant/.ssh

curl -o /home/vagrant/.ssh/authorized_keys -kL 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys

cat <<'EOF' > /home/vagrant/.bash_profile
[ -f ~/.bashrc ] && . ~/.bashrc
export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin
EOF

message "Recording box config date"
date > /etc/vagrant_box_build_time
