#!/usr/bin/perl -w

# Configuration
my $binDir = "/usr/bin/erd/";
my $agentInstallDir = "./agent-plugin/";
my $agentConfDir = "/etc/zabbix/zabbix_agentd.d";
my @files = (
    "ERD",
    "nodes_discovery.pl",
    "shards_discovery.pl",
    "node_status.pl",
    "node_statistics.pl",
    "validator_statistics.pl"
);

print("###\n### Installing the Elrond Zabbix Plugin.\n###\n");
print("Installing packages.\n");
system("apt install libwww-perl libjson-perl libcache-cache-perl -y 2>/dev/null");

print("Copying zabbix scripts:\n");
system("mkdir -p $binDir/ERD");
foreach my $file(@files){
    $filePath = $agentInstallDir . $file;
    print(" $filePath => $binDir\n");
    system("cp -r -f $filePath $binDir");
}

print("Setting up zabbix agent:\n");
my $agentConfig = $agentInstallDir . "erd_nodes.conf";
print(" $agentConfig => $agentConfDir\n");
system("cp -f $agentConfig $agentConfDir");

print("Restarting zabbix agent.\n");
system("service zabbix-agent restart");

print("### DONE!\n");
exit 0;
