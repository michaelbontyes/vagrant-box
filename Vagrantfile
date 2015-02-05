# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/trusty64"
	#config.vm.network "private_network", ip: "66.66.66.33"
	
	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 2
		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	end
	
	# install
	config.vm.provision :shell, run: "always", path: "shell/provision.sh"
	
	# ports
	config.vm.network :forwarded_port, host: 80, guest: 80
	config.vm.network :forwarded_port, host: 3306, guest: 3306
	
	# synced folders
	config.vm.synced_folder "./site", "/var/www/site", owner:'vagrant', group:'vagrant', mount_options: ['dmode=777', 'fmode=777']
end