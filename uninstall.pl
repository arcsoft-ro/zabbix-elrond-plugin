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

print("###\n### Uninstalling the Elrond Zabbix Plugin.\n###\n");
print("Removing zabbix scripts:\n");

foreach my $file(@oldfiles){
    $filePath = $oldbinDir . $file;
    print(" => $filePath\n");
    system("rm -f $filePath");
}

foreach my $file(@files){
    $filePath = $binDir . $file;
    print(" => $filePath\n");
    system("rm -f $filePath");
}

print("Removing sudoers configuration:\n");
print(" => $oldsudoersConf\n");
system("rm -f $oldsudoersConf");

print("Removing zabbix agent configuration:\n");
print(" => $oldagentConf\n");
system("rm -f $oldagentConf");
print(" => $agentConf\n");
system("rm -f $agentConf");

my $cacheRoot = "/var/run/zabbix/erd_cache";
print("Removing cache:\n");
print(" => $cacheRoot\n");
system("rm -rf $cacheRoot");

if(!$ARGV[0] || $ARGV[0] ne "skip-restart"){
    print("Restarting zabbix agent.\n");
    system("service zabbix-agent restart");
}

print("### DONE!\n");
exit 0;
