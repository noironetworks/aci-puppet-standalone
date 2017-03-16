class gbp::gbp_neutron_conf(
    $apic_username = hiera('CONFIG_APIC_USERNAME'),
    $apic_password = hiera('CONFIG_APIC_PW'),
    $apic_system_id = hiera('CONFIG_APIC_SYSTEM_ID'),
    $apic_provision_infra = hiera('CONFIG_APIC_PROVISION_INFRA'),
    $apic_provision_hostlinks = hiera('CONFIG_APIC_PROVISION_HOSTLINKS'),
    $apic_vpc_pairs = hiera('CONFIG_APIC_VPC_PAIRS'),
) {

$myint = hiera('CONFIG_GBP_MGMT_INTERFACE')
$myip = inline_template("<%= scope.lookupvar('::ipaddress_${myint}') -%>")


if hiera('CONFIG_APIC_PLUGIN_MODE') == 'gbp' {
   $service_plugins = 'group_policy,servicechain,apic_gbp_l3'
}
elsif hiera('CONFIG_APIC_PLUGIN_MODE') == 'unified'{
   $service_plugins = 'cisco_aim_l3,group_policy,servicechain'
   $core_plugin = 'ml2plus'
}
else {
   $service_plugins = 'cisco_apic_l3'
}

$inifile = { 'path' => '/etc/neutron/neutron.conf' }
$params = {
  'DEFAULT' => {
    'service_plugins'  => $service_plugins,
   }
  }
create_ini_settings($params, $inifile)

}
