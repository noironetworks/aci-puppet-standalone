class gbp::gbp_neutron_nova_api () {

   exec {'gbp_db':
      command => "/usr/bin/gbp-db-manage --config-file /etc/neutron/neutron.conf upgrade head",
      notify => Service['neutron-server'],
   }

   if !defined(Service['neutron-server']) {
      service {'neutron-server':
         ensure => running,
         enable => true,
      }
   }

   Nova_config<||> ~> Service['openstack-nova-api']

   nova_config {
     'neutron/allow_duplicate_networks': value => "true";
   }

   service {'openstack-nova-api':
      ensure => running,
      enable => true,
   }
}
