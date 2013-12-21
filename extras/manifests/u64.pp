# Default path
Exec { path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/local/bin'] }


# Configuration
if $domain == '' { $domain = 'localhost' }
if $db_name == '' { $db_name = 'development' }
if $db_location == '' { $db_location  = '/vagrant/db/development.sqlite' }
if $username == '' { $username = 'root' }
if $password == '' { $password = '123' }
if $host == '' { $host = 'localhost' }
if $docroot == '' { $host = 'docroot' }
if $aliases == '' { $aliases = 'localhost' }


class myinit {
  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS', 'Scientific', 'SLC', 'Ascendos', 'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL': {
      # $osfamily = 'RedHat'

      exec { "cleaner": 
        command => "rm -f /var/cache/yum/timedhosts.txt"
      }

      exec { "selinux-0":
        command => "echo \"0\" > /selinux/enforce"
      }

      class { "selinux":
        mode => disabled
      }

      include epel

      # exec { "Development Tools":
        # command => 'yum -y groupinstall "Development Tools"'
        # , unless => 'yum grouplist "Development Tools" | grep "^Installed Groups"'
      # }
      # ->
      # exec { "yum install screen": }

      package { "screen": 
        ensure => installed
      }

    }
    'ubuntu', 'debian': {
      # $osfamily = 'Debian'

      exec { 'apt-get update':
        command => '/usr/bin/apt-get update --fix-missing',
      }

    }
    'SLES', 'SLED', 'OpenSuSE', 'SuSE': {
      # $osfamily = 'Suse'
    }
    'Solaris', 'Nexenta': {
      # $osfamily = 'Solaris'
    }
    default: {
      # $osfamily = $::operatingsystem
    }
  }

  notify { "$::osfamily/$::operatingsystem": }
}


class myapache {
  require myinit
  
  class { "apache":
    default_mods  => false 
    , default_confd_files => false
  }
  
  apache::vhost { $domain:
    priority  => "20"
    , port => "80"
    , docroot => $docroot
    , logroot => $docroot # access_log and error_log
    , serveraliases => [$aliases]
    , directories => [{
      path => $docroot
      , allow_override => ["all"]
      , options => ["Indexes", "FollowSymLinks", "MultiViews"]
    }]
  }

  if $domain != "localhost" {
    apache::vhost { "localhost":
      priority  => "20"
      , port => "80"
        , docroot => "/vagrant/www"
      , logroot => "/vagrant/www" # access_log and error_log
      , directories => [{
        path => "/vagrant/www"
        , allow_override => ["all"]
        , options => ["Indexes", "FollowSymLinks", "MultiViews"]
      }]
    }
  }

  apache::mod { [
      # 'alias'
      'auth_basic'
    , 'auth_digest'
    , 'authn_file'
    , 'authn_alias'
    , 'authn_anon'
    , 'authn_dbm'
    , 'authn_default'
    , 'authz_user'
    , 'authz_owner'
    , 'authz_groupfile'
    , 'authz_dbm'
    , 'authz_default'
    , 'ldap'
    , 'include'
    , 'logio'
    , 'env'
    , 'ext_filter'
    , 'expires'
    , 'usertrack'
    , 'actions'
    , 'speling'
    , 'substitute'
    , 'proxy_balancer'
    , 'proxy_ftp'
    , 'proxy_connect'
    , 'suexec'
    , 'version'
    , 'autoindex'
    , 'cache'
    , 'cgi'
    , 'dav'
    , 'dav_fs'
    , 'deflate'
    , 'disk_cache'
    , 'headers'
    , 'info'
    # , 'mime'
    , 'mime_magic'
    , 'negotiation'
    , 'proxy'
    , 'proxy_ajp'
    , 'proxy_http'
    , 'rewrite'
    , 'setenvif'
    , 'status'
    , 'userdir'
    , 'vhost_alias'
    ]:
  }

}

class myphp {
  require myapache

  class { "php":
    # package => "php53"
    # , module_prefix => "php53-"
    # , service => "httpd"
  }

  include apache::mod::php

  php::module {[
    'cli'
    , 'common'
    , 'devel'
    , 'xml'
    , 'gd'
    , 'mbstring'
    , 'mcrypt'
    , 'mysql'
    , 'soap'
    , 'pdo'
    , 'xmlrpc'
    , 'bcmath'
    , 'snmp'
  ]:
  }
}


class mypear {
  include pear

  exec { "pear-upgrade-console":
    command => "pear upgrade --force Console_Getopt"
    , onlyif => "grep \"@version\s*Release: 1.4\" /usr/share/pear/PEAR.php"
    , require => [ Class['pear'] ]
  }
  exec { "pear-upgrade-force":
    command => "pear upgrade --force pear"
    , onlyif => "grep \"@version\s*Release: 1.4\" /usr/share/pear/PEAR.php"
    , require => [ Exec["pear-upgrade-console"] ]
  }
  exec { "pear-upgrade":
    command => "pear upgrade"
    , onlyif => "grep \"@version\s*Release: 1.4\" /usr/share/pear/PEAR.php"
    , require => [ Exec["pear-upgrade-force"] ]
  }

  exec { "install-structures_graph": 
    command => "wget -P /tmp http://download.pear.php.net/package/Structures_Graph-1.0.4.tgz && tar xvfz Structures_Graph-1.0.4.tgz && mv Structures_Graph-1.0.4/Structures /usr/share/pear"
    , cwd => "/tmp"
    , unless => "test -d /usr/share/pear/Structures"
    , require => [ Exec["pear-upgrade"] ]
  }

  exec { "pear install Structures_Graph":
    require => [ Exec["install-structures_graph"] ]
    , unless => "pear list | grep Structures_Graph"
  }

  exec {  "auto-discover":
    command => "pear config-set auto_discover 1"
    , unless => "test -d /usr/share/pear/PHPUnit"
    , require => [ Exec["pear-upgrade"] ]
  } 

  exec { "pear-channel-config":
    command => "pear channel-discover pear.phpunit.de"
    , require => [ Exec["pear-upgrade"] ]
    , unless => "pear list-channels | grep pear.phpunit.de"
  }
  ->
  exec { "pear-channel-config-component":
    command => "pear channel-discover components.ez.no"
    , unless => "pear list-channels | grep components.ez.no"
  }
  ->
  exec { "pear-channel-config-symfony":
    command => "pear channel-discover pear.symfony-project.com"
    , unless => "pear list-channels | grep pear.symfony-project.com"
  }

  # exec { "pear install pear.phpunit.de/PHPUnit":
  exec { "pear install --alldeps --force phpunit/PHPUnit":
    unless => "test -d /usr/share/pear/PHPUnit"
    , require =>  [ Exec["pear-channel-config"] ]
  }

  exec { "pear install --force phpunit/PHPUnit_MockObject":
    unless => "test -d /usr/share/pear/PHPUnit"
    , require =>  [ Exec["pear-channel-config"] ]
  }

  pear::package { "XML_Util":
    require =>  [ Exec["pear-upgrade"] ]
  }
}


class myimagemagick {
  require myphp

  package { [
      "gcc"
      , "ImageMagick"
      , "ImageMagick-devel"
      , "ImageMagick-perl"
    ]:
    ensure => installed
  }

  exec { "pecl install imagick":
    require => [ Package["ImageMagick"] ]
    , unless => "pecl list | grep imagick"
  }
  ->
  exec { "echo extension=imagick.so >> /etc/php.ini":
    notify => [ Service["httpd"] ]
    , unless => "grep imagick.so /etc/php.ini"
  }
}

class mymysql {
  require myphp

  class { '::mysql::server':
    root_password    => $password
    , remove_default_accounts => true
    , override_options => { 'mysqld' => { 'max_connections' => '1024' } }
  }

  mysql::db { $db_name:
    user  => $username
    , password  => $password
    , host  =>  $host
    , grant => ["all"]
    , charset => "utf8"
    , sql => $db_location
  } 
}


class mymisc {
  require myinit

  package { ['vim-enhanced','curl','unzip','git']:
    ensure  => installed
  }
  
  include composer
  include phpmyadmin
  include nodejs
  class { "ruby": }
}

include myinit
include myapache
include myphp
# include mypear
# include myimagemagick
# include mymysql
# include mymisc

