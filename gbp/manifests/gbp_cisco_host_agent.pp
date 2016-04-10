class gbp::gbp_cisco_host_agent(
) {

   $use_lldp = hiera('CONFIG_GBP_USE_LLDP')

   if ($use_lldp == "True") {
      service {'lldpad':
         ensure    => stopped,
         enable    => false,
      }

      service {'lldpd':
         ensure    => running,
         enable    => true,
         require   => Service['lldpad']
      }

      service {'neutron-cisco-apic-host-agent':
         ensure    => running,
         enable    => true,
         require   => Service['lldpd']
      }

   } else {

   }

}
