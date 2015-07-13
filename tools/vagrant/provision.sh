#!/bin/bash

failure=false

function error
{
	echo "ERROR: $*" >&2
	failure=true
}

function fatal
{
	echo "FATAL ERROR: $*" >&2
	exit 1
}

function warn
{
	echo "WARNING: $*" >&2
}

# Ensure that we have an internet connection by pinging Google DNS servers.
ping -w10 -c1 8.8.8.8 >/dev/null 2>&1 \
    || fatal "This VM is not connected to the internet."

sudo apt-get install -y software-properties-common
if [[ $? > 0 ]]; then
	error "failed to install software-properties-common."
fi

sudo apt-add-repository ppa:ansible/ansible
if [[ $? > 0 ]]; then
	error "failed to install Ansible PPA."
fi

sudo apt-get update
if [[ $? > 0 ]]; then
	error "failed to run apt-get update."
fi

sudo apt-get install -y ansible
if [[ $? > 0 ]]; then
	error "failed to install Ansible."
fi

echo "127.0.0.1" > /etc/ansible/hosts

sudo cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

sudo cp /vagrant/tools/vagrant/config/etc/ssh/ssh_config /etc/ssh/ssh_config

ansible-playbook -b /vagrant/tools/ansible/playbook.yml -vvvv

exit 0
