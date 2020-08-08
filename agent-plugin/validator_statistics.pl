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
    print("Arguments Error!\n"); exit 1;
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
        print("Could not fetch node status from $ipAddr:$port\n"); exit 2;
    }
}

my $validatorsStats = $vsCache->get($vsKeyPrefix . "all");
unless($validatorsStats){
    $validatorsStats = getValidatorStatistics($metaNodeUrl);
    if($validatorsStats){
        $vsCache->set($vsKeyPrefix . "all", $validatorsStats, $vsExpire);
    }
    else{
        print("Could not fetch validator statistics from $metaNodeUrl\n"); exit 3;
    }
}

my $nodePubKey = %$nodeInfo{$pubKeyProp};
unless($nodePubKey){
    print("Validator key not found in validator statistics result!\n"); exit 4;
}
my $validatorStats = %$validatorsStats{$nodePubKey};

my $retVal;
if($metric eq "erd_leader_success_percentage"){
    my $numLeaderSuccess = %$validatorStats{"numLeaderSuccess"};
    my $numLeaderFailure = %$validatorStats{"numLeaderFailure"};	
    my $totalNumLeaderSuccess = %$validatorStats{"totalNumLeaderSuccess"};
    my $totalNumLeaderFailure = %$validatorStats{"totalNumLeaderFailure"};
    if(looks_like_number($totalNumLeaderSuccess) && looks_like_number($totalNumLeaderFailure) && looks_like_number($numLeaderSuccess) && looks_like_number($numLeaderFailure)){
        $totalNumLeader = $totalNumLeaderSuccess + $totalNumLeaderFailure + $numLeaderSuccess + $numLeaderFailure;
        if($totalNumLeader == 0){
            $retVal = 100;
        }
        else{
            $retVal = 100 * (($totalNumLeaderSuccess + $numLeaderSuccess) / $totalNumLeader);
            $retVal = int($retVal * 1000) / 1000;
        }
    }
}
elsif($metric eq "erd_validator_success_percentage"){
    my $numValidatorSuccess = %$validatorStats{"numValidatorSuccess"};
    my $numValidatorFailure = %$validatorStats{"numValidatorFailure"};	
    my $totalNumValidatorSuccess = %$validatorStats{"totalNumValidatorSuccess"};
    my $totalNumValidatorFailure = %$validatorStats{"totalNumValidatorFailure"};
    if(looks_like_number($totalNumValidatorSuccess) && looks_like_number($totalNumValidatorFailure) && looks_like_number($numValidatorSuccess) && looks_like_number($numValidatorFailure)){
        $totalNumLeader = $totalNumValidatorSuccess + $totalNumValidatorFailure + $numValidatorSuccess + $numValidatorFailure;
        if($totalNumLeader == 0){
            $retVal = 100;
        }
        else{
            $retVal = 100 * (($totalNumValidatorSuccess + $numValidatorSuccess) / $totalNumLeader);
            $retVal = int($retVal * 1000) / 1000;
        }
    }
}
else{
    $retVal = %$validatorStats{$metric};
}

unless(defined($retVal)){
    print("Undefined return value!\n"); exit 5;
}

print "$retVal\n";

exit 0;
