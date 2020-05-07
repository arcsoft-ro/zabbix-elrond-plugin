#!/usr/bin/perl -w
use lib "./";
use lib "/usr/bin/erd";
use Getopt::Long;
use Cache::FileCache;
use Scalar::Util qw(looks_like_number);
use ERD::Utils;
use ERD::Api;

my $cacheNs = "ERD_VALIDATORSTATISTICS";
my $proto = "http";

my $metric = $ARGV[0];
my $ipAddr = $ARGV[1];
my $port = $ARGV[2];
my $metaNodeUrl = $ARGV[3];
my $expire = $ARGV[4] ? $ARGV[4] : $defaultExpire;
my $expireNodeStatus = $ARGV[5] ? $ARGV[5] : 3600;

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
        $cache->set($statusKeyPrefix . $port, $nodeInfo, $expireNodeStatus);
    }
    else{
	print("0\n"); exit 2;
    }
}

my $validatorsStats = $cache->get($statisticsKeyPrefix);
unless($validatorsStats){
    $validatorsStats = getValidatorStatistics($metaNodeUrl);
    if($validatorsStats){
        $cache->set($statisticsKeyPrefix, $validatorsStats, $expire);
    }
    else{
	print("0\n"); exit 3;
    }
}

my $nodePubKey = %$nodeInfo{$pubKeyProp};
unless($nodePubKey){
    print("0\n"); exit 3;
}
my $validatorStats = %$validatorsStats{$nodePubKey};

my $retVal;
if($metric eq "erd_leader_success_percentage"){
    my $totalNumLeaderSuccess = %$validatorStats{"totalNumLeaderSuccess"};
    my $totalNumLeaderFailure = %$validatorStats{"totalNumLeaderFailure"};
    if(looks_like_number($totalNumLeaderSuccess) && looks_like_number($totalNumLeaderFailure)){
        $totalNumLeader = $totalNumLeaderSuccess + $totalNumLeaderFailure;
        if($totalNumLeader == 0){
            $retVal = 100;
        }
        else{
            $retVal = 100 * ($totalNumLeaderSuccess / $totalNumLeader);
        $retVal = int($retVal * 1000) / 1000;
        }
    }
}
elsif($metric eq "erd_validator_success_percentage"){
    my $totalNumValidatorSuccess = %$validatorStats{"totalNumValidatorSuccess"};
    my $totalNumValidatorFailure = %$validatorStats{"totalNumValidatorFailure"};
    if(looks_like_number($totalNumValidatorSuccess) && ($totalNumValidatorFailure)){
        $totalNumLeader = $totalNumValidatorSuccess + $totalNumValidatorFailure;
        if($totalNumLeader == 0){
            $retVal = 100;
        }
        else{
            $retVal = 100 * ($totalNumValidatorSuccess / $totalNumLeader);
        $retVal = int($retVal * 1000) / 1000;
        }
    }
}
else{
    $retVal = %$validatorStats{$metric};
}

unless($retVal){
    print("0\n"); exit 3;
}

print "$retVal\n";
exit 0;
