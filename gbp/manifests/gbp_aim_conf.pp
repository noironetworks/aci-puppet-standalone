class gbp::gbp_aim_conf (
    $apic_username = hiera('CONFIG_APIC_USERNAME'),
    $apic_controller = hiera('CONFIG_APIC_CONTROLLER'),
    $apic_password = hiera('CONFIG_APIC_PW'),
    $admin_password = hiera('CONFIG_ADMIN_PW'),
    $apic_system_id = hiera('CONFIG_APIC_SYSTEM_ID'),
    $apic_provision_infra = hiera('CONFIG_APIC_PROVISION_INFRA'),
    $apic_provision_hostlinks = hiera('CONFIG_APIC_PROVISION_HOSTLINKS'),
    $apic_vpc_pairs = hiera('CONFIG_APIC_VPC_PAIRS'),
    $connection_string = hiera('CONFIG_GBP_CONNECTION_STRING'),
    $myint = hiera('CONFIG_GBP_MGMT_INTERFACE'),
) {

$myip = inline_template("<%= scope.lookupvar('::ipaddress_${myint}') -%>")


    if hiera('CONFIG_APIC_PLUGIN_MODE') != 'unified' {
       notify { "WILL NOT CONFIGURE AIM ": }
    }
    else {

    $inifile = { 'path' => '/etc/aim/aim.conf' }
    $params = {
      'DEFAULT' => {
          'debug' => 'True',
          'rpc_backend' => 'rabbit',
          'control_exchange' => 'neutron',
          'default_log_levels' => 'neutron.context=ERROR',

       },
      'oslo_messaging_rabbit' => {
          'rabbit_host' => $myip,
          'rabbit_port' =>  '5672',
          'rabbit_hosts' => "${myip}:5672",
          'rabbit_use_ssl' => 'False',
          'rabbit_userid' => 'guest',
          'rabbit_password' => 'guest',
          'rabbit_ha_queues' => 'False',

       },
      'database' => {
          'connection' => $connection_string,

       },
      'aim' => {
          'agent_down_time' => '75',
          'poll_config' => 'False',
          'aim_system_id' => $apic_system_id,
       },
      'apic' => {
#        'vni_ranges' => '11000:11100',
        'apic_hosts' => $apic_controller,
        'apic_username' => $apic_username,
        'apic_password' => $apic_password,
        'apic_use_ssl' => True,
       }
     }
     create_ini_settings($params, $inifile)
   }
    $inifile2 = { 'path' => '/etc/aim/aimctl.conf' }
    $params2 = {
      'DEFAULT' => {
          'apic_system_id' => $apic_system_id,
       },
      'apic' => {
        'apic_clear_node_profiles' => True,
        'enable_aci_routing' => True,
        'apic_arp_flooding' => True,
        'apic_name_mapping' => 'use_name',
        'enable_optimized_metadata' => 'True',
        'apic_provision_infra' => $apic_provision_infra,
        'apic_provision_hostlinks' => $apic_provision_hostlinks,
       },
      "apic_vmdom:${apic_system_id}" => {
          'encap' => 'vxlan',
       },

    }
     create_ini_settings($params2, $inifile2)

   service {'aim-aid':
     enable => true,
   }      
   service {'aim-event-service-polling':
     enable => true,
   }      
   service {'aim-event-service-rpc':
     enable => true,
   }      

}
