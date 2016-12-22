# aci-puppet-standalone
Puppet classes for installing and configuring opflex ACI neutron plugins. Instructions are in INSTALL file and also in docs directory

Limitations (all on roadmap)

    1. Only tested on CentOS/RDO
    2. Does not add leaf port configuration
    3. Does not modify neutron-server init/systemd file to add --config-file to read ml2_conf_cisco_apic.ini
    4. Only configures vxlan ecapsulation
    6. Does not generate yum/apt/zypper repo files
    7. Requires hiera
    8. Only create opflex interface files per CentOS/RedHat (/etc/sysconfig/network-scripts, /etc/dhcp)

