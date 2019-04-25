class farmfs {

  #package { "usbmount":
  #  ensure => installed,
  #} ->
  #file { '/etc/usbmount/usbmount.conf':
  #  ensure => file,
  #  content => file('farmfs/usbmount.conf'),
  #}
  #exec  { 'chown_usb_files':
  #  # User IDs are different from host to host.
  #  timeout => 0,
  #  command => '/bin/chown -R pi /media/*',
  #  unless => '/usr/bin/test `find /media/* ! -user pi | wc -l` == 0',
  #} 
  
  package { "xfsprogs":
    ensure => installed,
  }
  
  package { "hdparm":
    ensure => installed,
  }
  file { '/usr/local/bin/now':
    ensure => file,
    content => "#!/bin/bash\n date \"+%Y-%m-%d-%H:%M:%S\"",
    mode => '555',
  }

  package {'python-pip':
    ensure => installed,
  }
  
  package { 'farmfs': 
    require => Package['python-pip'],
    ensure  => latest,
    provider => pip,
  }

  file { '/etc/samba/':
    ensure => directory,
  } ->
  file { '/etc/samba/smb.conf':
    ensure => file,
    content => file('farmfs/smb.conf'),
    notify => Service['smbd'],
  } ->
  package { 'samba':
    ensure => installed,
    notify => Service['smbd'],
  }
  service { 'smbd':
    ensure => running,
  }

  package { 'screen':
    ensure => installed,
  }
}

