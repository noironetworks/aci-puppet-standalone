class gbp::gbp_neutron_ml2_cisco(
    $apic_username = hiera('CONFIG_APIC_USERNAME'),
    $apic_controller = hiera('CONFIG_APIC_CONTROLLER'),
    $apic_password = hiera('CONFIG_APIC_PW'),
    $admin_password = hiera('CONFIG_ADMIN_PW'),
    $apic_system_id = hiera('CONFIG_APIC_SYSTEM_ID'),
    $apic_provision_infra = hiera('CONFIG_APIC_PROVISION_INFRA'),
    $apic_provision_hostlinks = hiera('CONFIG_APIC_PROVISION_HOSTLINKS'),
    $apic_vpc_pairs = hiera('CONFIG_APIC_VPC_PAIRS'),
    $myint = hiera('CONFIG_GBP_MGMT_INTERFACE'),
) {

$myip = inline_template("<%= scope.lookupvar('::ipaddress_${myint}') -%>")
$inifile = { 'path' => '/etc/neutron/plugins/ml2/ml2_conf_cisco_apic.ini' }

if hiera('CONFIG_APIC_PLUGIN_MODE') == 'unified' {
#    notify { "FT WILL DO UNIFIED ${myip}": }
   $params = {
      'apic_aim_auth' => {
        'auth_pugin'  => 'v3password',
        'auth_url'  => "http://${myip}:35357/v3",
        'username' => 'admin',
        'password' => $admin_password,
        'user_domain_name' => 'default',
        'project_domain_name' => 'default',
        'project_name'  => 'admin',
        },
      'ml2_apic_aim' => {
        'enable_optimized_metadata' => 'True',
        }
      }

}
else{
    $params = {
      'DEFAULT' => {
        'apic_system_id'  => $apic_system_id
       },
       'opflex' => {
        'networks' => '*'
      },
      'ml2_cisco_apic' => {
        'vni_ranges' => '11000:11100',
        'apic_hosts' => $apic_controller,
        'apic_username' => $apic_username,
        'apic_password' => $apic_password,
        'apic_use_ssl' => True,
        'apic_clear_node_profiles' => True,
        'enable_aci_routing' => True,
        'apic_arp_flooding' => True,
        'apic_name_mapping' => 'use_name',
        'enable_optimized_metadata' => 'True',
        'apic_provision_infra' => $apic_provision_infra,
        'apic_provision_hostlinks' => $apic_provision_hostlinks,
       }
   }
}
create_ini_settings($params, $inifile)

if hiera('CONFIG_APIC_PLUGIN_MODE') == 'gbp' {

  $gbp_params = {
     'group_policy' => {
      'policy_drivers'  => 'implicit_policy,apic'
      },
     'group_policy_implicit_policy' => {
       'default_ip_pool' => '192.168.0.0/16'
     }
  }

  create_ini_settings($gbp_params, $inifile)
}
if hiera('CONFIG_APIC_PLUGIN_MODE') == 'unified' {

  $gbp_params = {
     'group_policy' => {
      'policy_drivers'  => 'aim-mapping',
      'extension_drivers'  => 'aim_extension,proxy_group'
      },
     'group_policy_implicit_policy' => {
       'default_ip_pool' => '192.168.0.0/16'
     }
  }

  create_ini_settings($gbp_params, $inifile)
}


$sw_params = ""

   define add_switch_conn_to_neutron_conf($sa, $sw_params) {
       $sid = keys($sa)
       a_s_c_t_n_c_1{$sid: swarr => $sa, sw_params => $sw_params}
   }
    
   define a_s_c_t_n_c_1($swarr, $sw_params) {
       $plist = $swarr[$name]
       $local_names = regsubst($plist, '$', "-$name")
       a_s_c_t_n_c_2 {$local_names: sid => $name, sw_params => $sw_params}
   }
    
   define a_s_c_t_n_c_2($sid, $sw_params) {
       $orig_name = regsubst($name, '-[0-9]+$', '')
       $arr = split($orig_name, ':')
       $host = $arr[0]
       $swport = $arr[1]
       $sw_params = "${sw_params}${host}"
       notify {
          "apic_switch:$sid host:$host port:$swport":
       }
#       neutron_config {
#          "apic_switch:$sid/$host": value => $swport;
#       }
   }
    
   $use_lldp = hiera('CONFIG_GBP_USE_LLDP')
   $swarr = "Junk"

   if ($use_lldp == true) {
   } else {
       notify { "use lldp disbled not supported yes": }
       add_switch_conn_to_neutron_conf{'xyz': sa => $swarr, sw_params => $sw_params}
   }

}
