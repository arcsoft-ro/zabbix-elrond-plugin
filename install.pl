#!/usr/bin/perl -w

# Configuration
my $binDir = "/usr/bin/";
my $agentInstallDir = "./agent-plugin/";
my $sudoersConf = "./conf/sudoers.d/zabbix";
my $sudoersConfDir = "/etc/sudoers.d";
my $agentConfDir = "/etc/zabbix/zabbix_agentd.d";
my @files = (
    "elrond_check.pl", 
    "elrond_discovery.pl"
);

print("Installing packages.\n");
`apt install libwww-perl libjson-perl -y 2>/dev/null`;

print("Copying zabbix scripts:\n");
foreach my $file(@files){
    $filePath = $agentInstallDir . $file;
    print(" $filePath => $binDir\n");
    `cp -f $filePath $binDir`;
}

print("Setting up sudo:\n");
print(" $sudoersConf => $sudoersConfDir\n");
`cp -f $sudoersConf $sudoersConfDir`;

print("Setting up zabbix agent:\n");
my $agentConfig = $agentInstallDir . "elrond_nodes.conf";
print(" $agentConfig => $agentConfDir\n");
`cp -f $agentConfig $agentConfDir`;

print("Restarting zabbix agent.\n");
`service zabbix-agent restart`;

print("DONE!\n");