class gbp::gbp_automation_ui() {

   package {'openstack-dashboard-gbp':
      ensure => installed,
      provider => yum,
   }

   if !defined(Package['openstack-heat-gbp']) {
      package {'openstack-heat-gbp':
         ensure => installed,
         provider => yum,
      }
   }

   service {'openstack-heat-engine':
     ensure => 'running',
     enable => true,
   }
   service {'openstack-heat-api':
     ensure => 'running',
     enable => true,
   }


   Heat_config<||> ~> Service['openstack-heat-api','openstack-heat-engine']

   heat_config {
      'DEFAULT/plugin_dirs': value => "/usr/lib/python2.7/site-packages/gbpautomation/heat";
   } ->
   file {'/etc/heat/api-paste.ini':
     content => template('gbp/heat-api-paste.ini.erb'),
   }

}
