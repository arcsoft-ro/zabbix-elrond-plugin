#!/usr/bin/perl -w

# Configuration
my $binDir = "/usr/bin/";
my $sudoersConf = "/etc/sudoers.d/zabbix";
my $agentConf = "/etc/zabbix/zabbix_agentd.d/elrond_nodes.conf";
my @files = (
    "elrond_check.pl",
    "elrond_discovery.pl"
);

print("Removing zabbix scripts:\n");

foreach my $file(@files){
    $filePath = $binDir . $file;
    print(" => $filePath\n");
    `rm -f $filePath`;
}

print("Removing sudoers configuration:\n");
print(" => $sudoersConf\n");
`rm -f $sudoersConf`;

print("Removing zabbix agent configuration:\n");
print(" => $agentConf\n");
`rm -f $agentConf`;

print ("Restarting Zabbix Agent.\n");
`service zabbix-agent restart`;

print("DONE!\n");