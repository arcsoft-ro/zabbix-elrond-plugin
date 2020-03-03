#!/usr/bin/perl -w

print("Removing zabbix scripts.\n");
my @files = (
    "/usr/bin/elrond_check.pl",
    "/usr/bin/elrond_discovery.pl"
);

foreach my $file(@files){
    print("Removing file $file\n");
    `rm -rf $file`;
}

print("Removing sudoers configuration.\n");
`rm -rf /etc/sudoers.d/zabbix`;

print("Removing zabbix agent configuration\n");
`rm -rf /etc/zabbix/zabbix_agentd.d/elrond_nodes.conf`;

print ("Restarting Zabbix Agent.\n");
`service zabbix-agent restart`;

print("DONE!\n");