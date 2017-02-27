# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = true
  config.vbguest.no_remote = true

  config.vm.box = 'puphpet/centos65-x64'
  config.vm.box_url = 'puphpet/centos65-x64'

  config.vm.network :forwarded_port, guest: 80, host: 8082
  config.vm.network :private_network, ip: '192.168.56.107'
  config.vm.synced_folder './', '/var/www', :mount_options => ['dmode=755', 'fmode=0664'] 

  config.vm.provision :shell, :path => 'shell/init.sh'
end
