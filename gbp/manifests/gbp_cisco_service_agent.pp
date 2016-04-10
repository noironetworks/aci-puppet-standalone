class gbp::gbp_cisco_service_agent(
) {

   $use_lldp = hiera('CONFIG_GBP_USE_LLDP')

   if ($use_lldp == "True") {
      service {'neutron-cisco-apic-service-agent':
         ensure    => running,
         enable    => true,
      }

   } else {
   }

}
