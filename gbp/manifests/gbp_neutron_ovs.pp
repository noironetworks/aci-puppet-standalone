class gbp::gbp_neutron_ovs() {

  if hiera('CONFIG_APIC_OS_VERSION') != 'kilo' {
  $inifile = { 'path' => '/etc/neutron/plugins/ml2/openvswitch_agent.ini' }
  }
  else {
  $inifile = { 'path' => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini' }
  }

  $myint = hiera('CONFIG_GBP_MGMT_INTERFACE')
  $myip = inline_template("<%= scope.lookupvar('::ipaddress_${myint}') -%>")


  $params =  {
       'ovs' => {
             'enable_tunneling' => 'False',
             'local_ip' => $myip,
             'tunnel_bridge' => {
                  'ensure' => 'absent'
             }
        },
        'agent' => {
             'vxlan_udp_port' => {
                  'ensure' => 'absent'
             },
             'tunnel_types' => {
                  'ensure' => 'absent'
             }
             
        }
   } 
   create_ini_settings($params, $inifile)
}
