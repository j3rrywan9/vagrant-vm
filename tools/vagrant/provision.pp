#
# Make sure our local apt sources are always up to date before trying to
# install any packages, otherwise the installation may fail.
#
class { 'apt':
    update => { 'frequency' => 'always' }
} -> Package <| |>

#
# Intall Ansible.
#
class ansible {
	#
	# Add Ansible PPA. See: http://docs.ansible.com/intro_installation.html
	#
	apt::ppa { "ppa:ansible/ansible": }
	->
	package { "ansible":
		ensure => "1.9.2-1ppa~trusty",
	}
}

include ansible
