#!/usr/bin/perl -w
use lib "./";
use lib "/usr/bin/erd";
use Getopt::Long;
use Cache::FileCache;
use ERD::Utils;
use ERD::Api;

my $cacheNs = "ERD_NODESTATUS";
my $proto = "http";

my $metric = $ARGV[0];
my $ipAddr = $ARGV[1];
my $port = $ARGV[2];
my $expire = $ARGV[3] ? $ARGV[3] : $defaultExpire;

unless($metric && $ipAddr && $port){
    print("0\n"); exit 1;
}

my $cache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $cacheNs,
    "default_expires_in" => $expire
});

my $nodeInfo = $cache->get($statusKeyPrefix . $port);
unless($nodeInfo){
    $nodeInfo = getNodeStatus($proto, $ipAddr, $port);
    if($nodeInfo){
        $cache->set($statusKeyPrefix . $port, $nodeInfo);
    }
    else{
	print("0\n"); exit 2;
    }
}

my $retVal;
if($metric eq "erd_new_version_exists"){
    my $version = %$nodeInfo{"erd_app_version"};
    my $latestVersion = %$nodeInfo{"erd_latest_tag_software_version"};
    if(startsWith($version, $latestVersion)){
	$retVal = 0;
    }
    else{
        $retVal = 1;
    }
}
else{
    $retVal = %$nodeInfo{$metric};
}

unless($retVal){
    print("0\n"); exit 3;
}

print "$retVal\n";
exit 0;
