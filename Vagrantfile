# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "cp533" do |cp533|
    cp533.vm.box = "centos5.9x64"
    cp533.vm.box_url = "http://tag1consulting.com/files/centos-5.9-x86-64-minimal.box"
    cp533.vm.network :forwarded_port, guest: 80, host: 8082
    cp533.vm.network :private_network, ip: "192.168.33.10"
    # cp533.vm.network :public_network
    # cp533.ssh.forward_agent = true
    cp533.vm.synced_folder "./data", "/vagrant/data", :mount_options => ['dmode=777', 'fmode=777'] 
    cp533.vm.synced_folder "./www", "/vagrant/www", :mount_options => ['dmode=777', 'fmode=777'] 

    cp533.vm.provision :shell, :path => "shell/init.sh"

    cp533.vm.provision :puppet do |puppet|
      puppet.facter = {
        # "fqdn"      => "localhost",
        "domain"    => "localhost",
        "aliases"   => "",
        "docroot"   => "/vagrant/www",
        "host"      => 'localhost',  # db host
        "username"  => 'paolo',      # db username
        "password"  => '123',        # db password
        "db_name"   => "development", # db name
        "db_location" => "/vagrant/data/db.sql"
      }
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = ["puppet/modules", "extras/modules"]
      puppet.manifest_file  = "init.pp"
    end
  end

  config.vm.define "u64" do |u64|
    u64.vm.box = "ubuntu-precise-64"
    u64.vm.box_url = "http://files.vagrantup.com/precise64.box"
    u64.vm.network :forwarded_port, guest: 80, host: 8083
    u64.vm.network :private_network, ip: "192.168.33.11"
    # u64.vm.network :public_network
    # u64.ssh.forward_agent = true
    u64.vm.synced_folder "./data", "/vagrant/data", :mount_options => ['dmode=777', 'fmode=777'] 
    u64.vm.synced_folder "./www", "/vagrant/www", :mount_options => ['dmode=777', 'fmode=777'] 

    # u64.vm.provision :shell, :path => "shell/init.sh"

    u64.vm.provision :puppet do |puppet|
      puppet.facter = {
        # "fqdn"      => "localhost",
        "domain"    => "localhost",
        "aliases"   => "",
        "docroot"   => "/vagrant/www",
        "host"      => 'localhost',  # db host
        "username"  => 'paolo',      # db username
        "password"  => '123',        # db password
        "db_name"   => "development", # db name
        "db_location" => "/vagrant/data/db.sql"
      }
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = ["puppet/modules", "extras/modules"]
      puppet.manifest_file  = "u64.pp"
    end
  end


end
