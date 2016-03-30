# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {

  $install_method     = 'url'
  $log_level          = 'info'
  $package_name       = 'consul-template'
  $package_ensure     = 'latest'
  $version            = '0.14.0'
  $download_url_base  = 'https://releases.hashicorp.com/consul-template/'
  $download_extension = 'zip'
  $user               = 'consul-template'
  $group              = 'consul-template'
  $manage_user        = true
  $manage_group       = true
  $config_mode        = '0660'

  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           { fail("Unsupported kernel architecture: ${::architecture}") }
  }

  $os = downcase($::kernel)

  $init_style = $::operatingsystem ? {
    'Ubuntu'        => $::lsbdistrelease ? {
      /^(12|13|14)/ => 'upstart',
      default       => 'systemd',
    },
    /CentOS|RedHat/ => $::operatingsystemmajrelease ? {
      /(4|5|6)/ => 'sysv',
      default   => 'systemd',
    },
    'Fedora'        => $::operatingsystemmajrelease ? {
      /(12|13|14)/ => 'sysv',
      default      => 'systemd',
    },
    'Debian'        => $::operatingsystemmajrelease ? {
      /(4|5|6|7)/ => 'debian',
      default     => 'systemd'
    },
    default => 'sysv'
  }
}
