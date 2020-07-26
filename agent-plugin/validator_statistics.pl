#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Cache::FileCache;
use Scalar::Util qw(looks_like_number);
use ERD::Utils;
use ERD::Api;

my $proto = "http";

my $metric = $ARGV[0];
my $ipAddr = $ARGV[1];
my $port = $ARGV[2];
my $metaNodeUrl = $ARGV[3];
my $vsExpire = $ARGV[4] ? $ARGV[4] : $vsExpireDefault;
my $nsExpire = $ARGV[5] ? $ARGV[5] : $nsExpireDefault;

unless($metric && $ipAddr && $port && $metaNodeUrl){
    print("0\n"); exit 1;
}

my $vsCache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $vsNameSpace,
    "default_expires_in" => $vsExpire
});

my $nsCache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $nsNameSpace,
    "default_expires_in" => $nsExpire
});

my $nodeInfo = $nsCache->get($nsKeyPrefix . $port);
unless($nodeInfo){
    $nodeInfo = getNodeStatus($proto, $ipAddr, $port);
    if($nodeInfo){
        $nsCache->set($nsKeyPrefix . $port, $nodeInfo, $nsExpire);
    }
    else{
        print("0\n"); exit 2;
    }
}

my $validatorsStats = $vsCache->get($vsKeyPrefix . "all");
unless($validatorsStats){
    $validatorsStats = getValidatorStatistics($metaNodeUrl);
    if($validatorsStats){
        $vsCache->set($vsKeyPrefix . "all", $validatorsStats, $vsExpire);
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

unless($retVal || looks_like_number($retVal)){
    print("0\n"); exit 4;
}

print "$retVal\n";

exit 0;
