# aci-puppet-standalone
Puppet classes for installing and configuring opflex ACI neutron plugins

Limitations (all on roadmap)

    Only tested on CentOS/RDO

    Does not add leaf port configuration

    Does not modify neutron-server init/systemd file to add --config-file to read ml2_conf_cisco_apic.ini

    Only configures vxlan ecapsulation

    Generates config for agent-ovs as single file instead of overriding in conf.d

    Does not generate yum/apt/zypper repo files

    Requires hiera

