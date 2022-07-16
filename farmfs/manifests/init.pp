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

  $mount_point_opts = {
    ensure => directory,
    group => 'pi',
    owner => 'pi',
    mode => '0664',
  }
  $mount_opts = {
    ensure => mounted,
    atboot => true,
    fstype => 'xfs',
    options => 'nofail,rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota', # See fstab(5)
    remounts => true,
    require => Package['xfsprogs'],
  }
  file { "/media/ssd1":
    * => $mount_point_opts,
  } ->
  mount { "/media/ssd1":
    device => "/dev/sda",
    * => $mount_opts,
  }
  file { "/media/ssd2":
    * => $mount_point_opts,
  } ->
  mount { "/media/ssd2":
    device => "/dev/sdb",
    * => $mount_opts,
  }
  file { "/media/ssd3":
    * => $mount_point_opts,
  } ->
  mount { "/media/ssd3":
    device => "/dev/sdc",
    * => $mount_opts,
  }
  file { "/media/ssd4":
    * => $mount_point_opts,
  } ->
  mount { "/media/ssd4":
    device => "/dev/sdd",
    * => $mount_opts,
  }

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

  package {'python3-pip':
    ensure => installed,
  }

  #package { 'farmfs':
  #  require => Package['python-pip'],
  #  ensure  => latest,
  #  provider => pip,
  #}

  file { '/etc/samba/':
    ensure => directory,
  } ->
  file { '/etc/samba/smb.conf':
    ensure => file,
    content => file('farmfs/smb.conf'),
    notify => Service['smbd'],
  } ->
  #package { 'libpam-smbpass':
  #  ensure => installed,
  #  notify => Service['smbd'],
  #} ->
  package { 'samba':
    ensure => installed,
    notify => Service['smbd'],
  }
  service { 'smbd':
    ensure => running,
  }

  user { "farmfs":
    ensure => present,
    # Password is 'farmfs'. To compute the hash run `passwd -1` and type a password.
    # See this article for more information: https://codingbee.net/puppet/puppet-setting-user-password
    password => '$1$nnngyDlW$/1CT9/4mPITHGsMkpN5661',
  }

  package { 'screen':
    ensure => installed,
  }
  package { 'vim':
    ensure => installed,
  }
}

