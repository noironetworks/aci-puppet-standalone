include stdlib
include  gbp


class {'gbp::gbp_neutron_ovs':
    require => Class['gbp'],
}


if hiera('CONFIG_APIC_ROLE') == 'controller' {

    class { 'gbp::gbp_neutron_conf':
       require => Class['gbp'],
    }
    class { 'gbp::gbp_neutron_ml2':
       require => Class['gbp'],
    }
    class { 'gbp::gbp_neutron_ml2_cisco': 
       require => Class['gbp'],
    }
    class { 'gbp::gbp_neutron_dhcp': 
      require => Class['gbp'],
    }
    class { 'gbp::gbp_aim_conf': 
      require => Class['gbp'],
    }
}
else{
    class {'gbp::gbp_opflex_interface':
      require => Class['gbp'],
   }
    class {'gbp::opflex_agent':
      require => Class['gbp'],
    }
}

