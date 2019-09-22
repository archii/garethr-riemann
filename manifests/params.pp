class riemann::params {
  $version = '0.2.4'
  $install_source = 'https://github.com/riemann/riemann/releases/download/'
  $config_file = '/etc/riemann.sample.config'
  $dash_path = "/usr/local/ruby/bin/riemann_dash"
  $dash_port = 4567
  $dash_host = 'localhost'
  $dash_user = 'riemann-dash'
  $net_user = 'riemann-net'
  $health_user = 'riemann-health'
  $enable_puppet_reports = false
  $port = 5555
  $host = 'localhost'
  $user = 'riemann'
  $rvm_ruby_string = undef
  $extra_jars = []

  case $::osfamily {
    'Debian': {
      $service_provider = upstart
      $libxml_package = 'libxml2-dev'
      $libxslt_package = 'libxslt1-dev'
    }
    'RedHat', 'Amazon': {
      include epel
      $service_provider = $::operatingsystemmajrelease ? {
        '7' => systemd,
        default => redhat
      }
      $libxml_package = 'libxml2-devel'
      $libxslt_package = 'libxslt-devel'
      $gem_path = $::operatingsystemrelease ? {
        '5.8'   => '/usr/local/bin/',
        default => '/usr/bin/',
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
