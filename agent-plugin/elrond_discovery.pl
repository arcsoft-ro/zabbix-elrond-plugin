#!/usr/bin/perl -w
use LWP::Simple;
use JSON;
use Getopt::Std;
use Cache::FileCache;

getopts("e:" => \%opts);

my $expire;
if(defined($opts{"e"})){
    $expire = $opts{"e"} * 1000;
}
else{
    $expire = 60;
}

my $cacheRoot = "/var/run/zabbix/elrond_cache";
my $cacheNs = "ERD_DISCOVERY";

my $cache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $cacheNs,
    "default_expires_in" => $expire
});

my $nodeStatusKey = "nodeStatus";
my $serviceConfigDir = "/etc/systemd/system/";

opendir(DIR, $serviceConfigDir);
@configFiles = grep(/elrond-node-.*\.service$/, readdir(DIR));
closedir(DIR);

my $jsonString = "[";
foreach my $configFile(@configFiles){
    open my $fh, '<', $serviceConfigDir . $configFile or die "Cannot open file: $!\n";
    while(<$fh>) {
	if($_ =~ /^\s*[^#].+rest-api-interface.+$/){
	    chomp;
	    my @parts = split(/:/,$_);
    	    my $port = $parts[1];
	    @parts = split(/\s+/,$parts[0]);
	    my $ipAddr = $parts[$#parts];
	    my $nodeInfo = $cache->get($nodeStatusKey . $port);
	    unless($nodeInfo){
	        $nodeUrl = "http://" . $ipAddr . ":" . $port . "/node/status";
		$content = get($nodeUrl);
		if($content){
    		    $nodeStatus = from_json($content);
		    my $values = %$nodeStatus{"details"};
		    $nodeInfo = $values;
    	    	    $cache->set($nodeStatusKey . $port, $values);
		}
	    }
	    my $nodeName = %$nodeInfo{"erd_node_display_name"};
	    if($nodeName){
		$jsonString .= "{\"{#NODENAME}\":\"$nodeName\",\"{#NODEPORT}\":\"$port\"},";
	    }
    	    else{
	        $jsonString .= "{\"{#NODENAME}\":\"$port\",\"{#NODEPORT}\":\"$port\"},";
	    }
	}
    }
}

$jsonString =~ s/,+$//;
print ($jsonString . "]\n");

exit 1;
