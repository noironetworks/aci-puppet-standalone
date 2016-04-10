class gbp::gbp_neutron_dhcp() {

#   Neutron_dhcp_agent_config<||> ~> Service['neutron-dhcp-agent']

    $inifile = { 'path' => '/etc/neutron/dhcp_agent.ini' }

    $params = {
      'DEFAULT' => {
        'ovs_integration_bridge'  => 'br-int',
        'enable_isolated_metadata'  => 'True'
       }
    }
    create_ini_settings($params, $inifile)

   service {'neutron-dhcp-agent':
      ensure => running,
      enable => true,
   }

   service {'neutron-l3-agent':
      ensure => stopped,
      enable => false,
   }

#   service {'neutron-openvswitch-agent':
#      ensure => stopped,
#      enable => false,
#   }

   service {'neutron-metadata-agent':
      ensure => stopped,
      enable => false,
   }
  
}
