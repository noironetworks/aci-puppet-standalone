# this is all temporary.. till the packages are available

class gbp() {

    service {'neutron-openvswitch-agent':
        ensure => stopped,
        enable => false,
    }

   if !defined(Package['apicapi']) {
      package {'apicapi':
         ensure => installed,
      }
   }
    
   if !defined(Package['python-pbr']) {
      package { 'python-pbr':
         ensure => installed,
      }
   }
    

   if !defined(Package['python-pip']) {
      package { 'python-pip':
         ensure => installed,
      }
   }
        
   if !defined(Package['neutron-ml2-driver-apic']) {
      package {'neutron-ml2-driver-apic':
         ensure => installed,
      }
   }

   if hiera('CONFIG_APIC_ROLE') == 'controller' {
       
       if hiera('CONFIG_APIC_PLUGIN_MODE') != 'gbp' {

           if !defined(Package['openstack-neutron-gbp']) {
              package {'openstack-neutron-gbp':
                 ensure => installed,
              }
           }
        
           if !defined(Package['python-gbpclient']) {
              package {'python-gbpclient':
                 ensure => installed,
              }
           }
        
           if !defined(Package['openstack-heat-gbp']) {
              package {'openstack-heat-gbp':
                 ensure => installed,
              }
           }
        
           if !defined(Package['openstack-dashboard-gbp']) {
              package {'openstack-dashboard-gbp':
                 ensure => installed,
              }
           }
        
           if !defined(Package['python-django-horizon-gbp']) {
              package {'python-django-horizon-gbp':
                 ensure => installed,
              }
           }
       }
       if hiera('CONFIG_APIC_PLUGIN_MODE') != 'unified' {

           if !defined(Package['openstack-neutron-gbp']) {
              package {'openstack-neutron-gbp':
                 ensure => installed,
              }
           }

           if !defined(Package['python-gbpclient']) {
              package {'python-gbpclient':
                 ensure => installed,
              }
           }

           if !defined(Package['openstack-heat-gbp']) {
              package {'openstack-heat-gbp':
                 ensure => installed,
              }
           }

           if !defined(Package['openstack-dashboard-gbp']) {
              package {'openstack-dashboard-gbp':
                 ensure => installed,
              }
           }

           if !defined(Package['python-django-horizon-gbp']) {
              package {'python-django-horizon-gbp':
                 ensure => installed,
              }
           }
       }

    }
    else {
    
       if !defined(Package['neutron-opflex-agent']) {
          package {'neutron-opflex-agent':
             ensure => installed,
          }
       }
    
    }
}
