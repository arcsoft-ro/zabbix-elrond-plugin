#!/usr/bin/perl -w

# Configuration
my $binDir = "/usr/bin/erd/";
my $agentConf = "/etc/zabbix/zabbix_agentd.d/erd_nodes.conf";
my $oldbinDir = "/usr/bin/";
my $oldsudoersConf = "/etc/sudoers.d/zabbix";
my $oldagentConf = "/etc/zabbix/zabbix_agentd.d/elrond_nodes.conf";

my @files = (
    "ERD/Api.pm",
    "ERD/Utils.pm",
    "discovery.pl",
    "node_status.pl",
    "validator_statistics.pl"
);

my @oldfiles = (
    "elrond_check.pl",
    "elrond_discovery.pl"
);

print("Removing zabbix scripts:\n");

foreach my $file(@oldfiles){
    $filePath = $oldbinDir . $file;
    print(" => $filePath\n");
    `rm -f $filePath`;
}

foreach my $file(@files){
    $filePath = $binDir . $file;
    print(" => $filePath\n");
    `rm -f $filePath`;
}


print("Removing sudoers configuration:\n");
print(" => $oldsudoersConf\n");
`rm -f $oldsudoersConf`;

print("Removing zabbix agent configuration:\n");
print(" => $oldagentConf\n");
`rm -f $oldagentConf`;
print(" => $agentConf\n");
`rm -f $agentConf`;

print ("Restarting Zabbix Agent.\n");
`service zabbix-agent restart`;

print("DONE!\n");