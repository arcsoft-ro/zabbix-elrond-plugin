#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Cache::FileCache;
use Scalar::Util qw(looks_like_number);
use ERD::Utils;
use ERD::Api;

my $metaNodeUrl = $ARGV[0];
my $metric = $ARGV[1];
my $shardId = $ARGV[2];
my $hsExpire = $ARGV[3] ? $ARGV[3] : $hsExpireDefault;

if($shardId eq "meta"){
    $shardId = 4294967295;
}

if($shardId eq "all"){
    $shardId = -1;
}

unless($metaNodeUrl && $metric && looks_like_number($shardId) && $shardId >= -1){
    print("Arguments Error!\n"); exit 1;
}

my $hsCache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $hsNameSpace,
    "default_expires_in" => $hsExpire
});

my $heartBeats = $hsCache->get($hsKeyPrefix . "heartbeats");

unless($heartBeats){

    $heartBeats = getHeartBeatStatus($metaNodeUrl);

    if($heartBeats){
        $hsCache->set($hsKeyPrefix . "heartbeats", $heartBeats, $hsExpire);
    }
    else{
        print("Could not fetch HeartbeatStatus from $metaNodeUrl\n"); exit 2;
    }
}

my $latestVersion = $hsCache->get($hsKeyPrefix . "latestversion");

unless($latestVersion){

    $latestVersion = getRepoInfo("https://api.github.com/repos/ElrondNetwork/elrond-config-mainnet/releases/latest","tag_name");

    if($latestVersion){
        $hsCache->set($hsKeyPrefix . "latestversion", $latestVersion, $hsExpire);
    }
    else{
        print("Could not fetch repository latest version!\n"); exit 3;
    }
}

my $totalValidators = 0;
my $activeValidators = 0;
my $inactiveValidators = 0;
my $outdatedValidators = 0;
my $shardTotalValidators = 0;
my $shardActiveValidators = 0;
my $shardInactiveValidators = 0;
my $shardOutdatedValidators = 0;

foreach $heartBeat (@$heartBeats){

    my $peerType = %$heartBeat{"peerType"};
    unless ($peerType && ($peerType eq "eligible" || $peerType eq "waiting")){
	next;
    }

    my $validatorStatus = %$heartBeat{"isActive"} ? 1 : 0;
    my $validatorVersion = %$heartBeat{"versionNumber"};
    my $validatorShard = %$heartBeat{"computedShardID"};


    if($validatorShard == $shardId){
	$shardTotalValidators++;
	if($validatorStatus){
	    $shardActiveValidators++;
	}
	else{
	    $shardInactiveValidators++;
	}
	unless(startsWith($validatorVersion,$latestVersion)){
	    $shardOutdatedValidators++;
	}
    }
    else{
        $totalValidators++;
        if($validatorStatus){
            $activeValidators++;
	}
	else{
	    $inactiveValidators++;
	}
	unless(startsWith($validatorVersion,$latestVersion)){
	    $outdatedValidators++;
	}	
    }
}

if($metric eq "erd_shard_total_validators"){
    $retVal = $shardTotalValidators;
}
elsif($metric eq "erd_shard_active_validators"){
    $retVal = $shardActiveValidators;
}
elsif($metric eq "erd_shard_inactive_validators"){
    $retVal = $shardInactiveValidators;
}
elsif($metric eq "erd_shard_outdated_validators"){
    $retVal = $shardOutdatedValidators;
}
if($metric eq "erd_total_validators"){
    $retVal = $totalValidators;
}
elsif($metric eq "erd_active_validators"){
    $retVal = $activeValidators;
}
elsif($metric eq "erd_inactive_validators"){
    $retVal = $inactiveValidators;
}
elsif($metric eq "erd_outdated_validators"){
    $retVal = $outdatedValidators;
}

unless(defined($retVal)){
    print("Undefined return value!\n"); exit 3;
}

print "$retVal\n";

exit 0;
