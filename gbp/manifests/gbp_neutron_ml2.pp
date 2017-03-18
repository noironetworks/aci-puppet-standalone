class gbp::gbp_neutron_ml2 () {

    $inifile = { 'path' => '/etc/neutron/plugins/ml2/ml2_conf.ini' }
    if hiera('CONFIG_APIC_PLUGIN_MODE') == 'gbp' {
       $mech = 'apic_gbp'
    $params = {
      'ml2' => {
        'type_drivers'  => 'opflex,local,flat,vlan,gre,vxlan',
        'tenant_network_types'  => 'opflex',
        'mechanism_drivers'  => $mech,
       },
     }

    }
    elsif hiera('CONFIG_APIC_PLUGIN_MODE') == 'unified' {
       $mech = 'apic_aim'
    $params = {
      'ml2' => {
        'type_drivers'  => 'opflex,local,flat,vlan,gre,vxlan',
        'tenant_network_types'  => 'opflex',
        'mechanism_drivers'  => $mech,
        'extension_drivers'  => $mech,
       },
     }

    }
    else {
       $mech = 'cisco_apic_ml2'
    $params = {
      'ml2' => {
        'type_drivers'  => 'opflex,local,flat,vlan,gre,vxlan',
        'tenant_network_types'  => 'opflex',
        'mechanism_drivers'  => $mech,
       },
     }

    }

create_ini_settings($params, $inifile)

}

