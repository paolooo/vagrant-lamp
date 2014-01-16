Vagrant LAMP
============

by Nino Paolo Amarillento

### al
# test
# wetwe

### Installation

- Download [Vagrant](http://downloads.vagrantup.com/)   
- Download [Virtualbox](https://www.virtualbox.org/wiki/Downloads)    
- Clone vagrant-lamp git repo   
  `git clone git://github.com/paolooo/vagrant-lamp.git lamp`  
  `cd lamp`
- Update submodule    
   `git submodule update --init --recursive`
- Run vagrant   
   `vagrant up`
- After installation is done, and encountered missing packages. You should run
   `vagrant provision`
- Log to Vagrant Virtualbox Lamp Environment    
  host: `localhost`   
  port: `2222`    
  username: `vagrant`   
  password: `vagrant`
- Check packages
  `$ php -v`    
  `$ mysql --version`   
  `$ sqlite -version`   
  `$ psql --version`    
  `$ phpunit --version`   
  `$ composer --version`    
  `$ ruby --version`    
  `$ gem --version`   
  `$ node --version`    
  `$ npm --version`   
  

### To fix the error
$ sudo apt-get purge apache2
$ sudo apt-get install apache2-mpm-prefork

### Usage
Navigate to `http://localhost:8082`


### Vagrant SSH 
Simply run `vagrant ssh`. If you're using windows, you need putty to access this.

Here's the instructions for Windows users:

* Run Putty. If you don't have one yet you can download Putty [here](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
* Host Name: `localhost`
* Port: `2222`
* login as: `vagrant`
* password: `vagrant`


### Vagrant Commands
* `vagrant up`
* `vagrant reload`
* `vagrant halt`
* `vagrant destroy`
* `vagrant ssh`
* `vagrant status`



### Bash Scripts
  * Laravel 4 (https://gist.github.com/paolooo/5292362) - This will download laravel 4 automatically for you

### Credit
* [VagrantUp](http://vagrantup.com/)
* [VirtualBox](http://virtualbox.com)
* [PuppetLabs](https://github.com/puppetlabs)
* [Alessandro Franceschi](https://github.com/example42/)
