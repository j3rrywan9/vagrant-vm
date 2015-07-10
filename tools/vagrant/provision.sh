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

function install_puppet_module
{
    local module=$1

    if ! puppet module --modulepath=/etc/puppet/modules list | \
        grep $module >/dev/null; then
        sudo puppet module install $module || \
            error "failed to install puppet module ${module}"
    fi
}

# Ensure that we have an internet connection by pinging Google DNS servers.
ping -w10 -c1 8.8.8.8 >/dev/null 2>&1 \
    || fatal "This VM is not connected to the internet."

install_puppet_module "puppetlabs-apt"

sudo puppet apply --detailed-exitcodes /vagrant/tools/vagrant/provision.pp
puppet_exit=$?

#
# Puppet will exit 0 if there were no changes or errors, 2 if there were
# changes and no errors, and 4 or 6 if there were errors.
#
[[ $puppet_exit -eq 0 ]] || [[ $puppet_exit -eq 2 ]] || error "puppet failed"
	
exit 0
