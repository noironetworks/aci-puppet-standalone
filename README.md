# aci-puppet-standalone
Puppet classes for installing and configuring opflex ACI neutron plugins

Limitations (all on roadmap)

    1. Only tested on CentOS/RDO
    2. Does not add leaf port configuration
    3. Does not modify neutron-server init/systemd file to add --config-file to read ml2_conf_cisco_apic.ini
    4. Only configures vxlan ecapsulation
    5. Generates config for agent-ovs as single file instead of overriding in conf.d
    6. Does not generate yum/apt/zypper repo files
    7. Requires hiera

