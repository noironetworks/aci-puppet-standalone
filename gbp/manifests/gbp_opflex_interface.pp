class gbp::gbp_opflex_interface () {

    $uplink_int =  hiera('CONFIG_GBP_OPFLEX_UPLINK_INTERFACE')
    $uplink_vlan = hiera('CONFIG_GBP_OPFLEX_UPLINK_VLAN')
    $uplink_mtu =  hiera('CONFIG_GBP_OPFLEX_INTERFACE_MTU')

    if hiera('CONFIG_GBP_CREATE_UPLINK_PARENT') == true {
        network::interface {$uplink_int:
                            enable_dhcp => false,
                            mtu => $uplink_mtu,}
        }
    else {
        notify{"Skipping creation of parent interface $uplink_int, please ensure that it has equal or higher mtu than $uplink_mtu":} 
        }
    network::interface {"$uplink_int.$uplink_vlan":
                        enable_dhcp => true,
                        vlan => yes,
                        mtu => $uplink_mtu,}

    network::route { "$uplink_int.$uplink_vlan":
      ipaddress => [ '224.0.0.0', ],
      netmask   => [ '240.0.0.0', ],
      gateway   => [ '0.0.0.0', ],
    }

   $mymac = inline_template("<%= scope.lookupvar('::macaddress_${uplink_int}') -%>")
   file {'dhclient-conf':
     path => "/etc/dhcp/dhclient-$uplink_int.$uplink_vlan.conf",
     mode => '0644',
     content => template('gbp/dhclient-interface.conf.erb'),
   }

}

