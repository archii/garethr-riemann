class riemann::config {
  $host = $riemann::host
  $port = $riemann::port
  $config_file = $riemann::config_file
  $user = $riemann::user

  case $::osfamily {
    'Debian': {
      file { '/etc/init.d/riemann':
        ensure => link,
        target => '/lib/init/upstart-job',
      }

      file { '/etc/init/riemann.conf':
        ensure  => present,
        content => template('riemann/etc/init/riemann.conf.erb'),
      }
    }
    'RedHat', 'Amazon': {
      case $::operatingsystemmajrelease {
        '7'     : {
          file { '/usr/lib/systemd/system/riemann.service':
            ensure  => present,
            mode    => '0644',
            content => template('riemann/usr/lib/systemd/system/riemann.service.erb'),
          }~>
          exec { '/bin/systemctl daemon-reload':
            refreshonly => true,
          }
        }
        default : {
          file { '/etc/init.d/riemann':
            ensure  => present,
            mode    => '0755',
            content => template('riemann/etc/init/riemann.conf.redhat.erb'),
          }
        }
      }
    }
    default: {}
  }

  file { '/etc/riemann.sample.config':
    ensure => present,
    source => 'puppet:///modules/riemann/etc/riemann.config',
    owner  => $user,
  }

  file { '/etc/puppet/riemann.yaml':
    ensure  => present,
    content => template('riemann/etc/puppet/riemann.yaml.erb'),
  }

  file { '/var/log/riemann.log':
    owner => $user,
  }

}
