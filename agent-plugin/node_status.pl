#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Getopt::Long;
use Cache::FileCache;
use Scalar::Util qw(looks_like_number);
use ERD::Utils;
use ERD::Api;

my $proto = "http";

my $metric = $ARGV[0];
my $host = $ARGV[1];
my $port = $ARGV[2];
my $nsExpire = $ARGV[3] ? $ARGV[3] : $nsExpireDefault;

unless($metric && $host && $port){
    print("0\n"); exit 1;
}

my $nsCache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $nsNameSpace,
    "default_expires_in" => $nsExpire
});

my $nodeInfo = $nsCache->get($nsKeyPrefix . $port);
unless($nodeInfo){
    $nodeInfo = getNodeStatus($proto, $host, $port);
    if($nodeInfo){
        $nsCache->set($nsKeyPrefix . $port, $nodeInfo);
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

unless($retVal || looks_like_number($retVal)){
    print("0\n"); exit 3;
}

print "$retVal\n";
exit 0;
