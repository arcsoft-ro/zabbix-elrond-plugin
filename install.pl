#!/usr/bin/perl -w

print("Installing packages.\n");
`apt install libwww-perl libjson-perl -y 2>/dev/null`;

print("Copying zabbix scripts.\n");
my $targetDir = "/usr/bin";
my @files = ("elrond_check.pl", "elrond_discovery.pl");
foreach my $file(@files){
    print("Copying file $file\n");
    `cp $file $targetDir`;
}

print("Setting up sudo.\n");
`cp zabbix /etc/sudoers.d`;

print("Copying zabbix agent config file.\n");
`cp elrond_nodes.conf /etc/zabbix/zabbix_agentd.d`;

print("Restarting zabbix agent.\n");
`service zabbix-agent restart`;

print("DONE!\n");