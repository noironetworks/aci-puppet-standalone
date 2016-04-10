class gbp::gbp_nova() {

   exec {'change_nova_shell':
      command => "/usr/sbin/usermod -s /bin/bash nova",
      notify => Service['openstack-nova-compute'],
   }

   service {'openstack-nova-compute':
      ensure => running,
      enable => true,
   }

}
