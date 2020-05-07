#!/usr/bin/perl -w
use lib "./";
use lib "/usr/bin/erd";
use Getopt::Long;
use Cache::FileCache;
use ERD::Utils;
use ERD::Api;

my $cacheNs = "ERD_DISCOVERY";

my $expire = $ARGV[0] ? $ARGV[0] : 86400;

my $cache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $cacheNs,
    "default_expires_in" => $expire
});

my $serviceConfigDir = "/etc/systemd/system/";

opendir(DIR, $serviceConfigDir);
@configFiles = grep(/elrond-node-.*\.service$/, readdir(DIR));
closedir(DIR);

my $jsonString = "[";
foreach my $configFile(@configFiles){
    open my $fh, '<', $serviceConfigDir . $configFile or die "Cannot open file: $!\n";
    while(<$fh>) {
	if(configLineContains($_,"rest-api-interface")){
	    chomp;
	    my @parts = split(/:/,$_);
    	    my $port = $parts[1];
	    @parts = split(/\s+/,$parts[0]);
	    my $ipAddr = $parts[$#parts];
	    my $nodeInfo = $cache->get($statusKeyPrefix . $port);
	    unless($nodeInfo){
		$nodeInfo = getNodeStatus("http", $ipAddr, $port);
		if($nodeInfo){
    	    	    $cache->set($statusKeyPrefix . $port, $nodeInfo);
		}
	    }
	    my $nodeName = %$nodeInfo{"erd_node_display_name"};
	    unless($nodeName){
		$nodeName = $hostName . ":" . $port;
	    }
	    $jsonString .= "{\"{#NODENAME}\":\"$nodeName\",\"{#NODEIP}\":\"$ipAddr\",\"{#NODEPORT}\":\"$port\"},";
	}
    }
}

$jsonString =~ s/,+$//;
print ($jsonString . "]\n");

exit 1;
