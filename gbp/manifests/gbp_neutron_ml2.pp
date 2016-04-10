class gbp::gbp_neutron_ml2 () {

    if hiera('CONFIG_APIC_PLUGIN_MODE') == 'gbp' {
       $mech = 'apic_gbp'
    }
    else {
       $mech = 'cisco_apic_ml2'
    }

    $inifile = { 'path' => '/etc/neutron/plugins/ml2/ml2_conf.ini' }
    $params = {
      'ml2' => {
        'type_drivers'  => 'opflex,local,flat,vlan,gre,vxlan',
        'tenant_network_types'  => 'opflex',
        'mechanism_drivers'  => $mech,
       },
     }
create_ini_settings($params, $inifile)

}

