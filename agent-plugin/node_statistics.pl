#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Scalar::Util qw(looks_like_number);
use ERD::Utils;
use ERD::Api;

my $metaNodeUrl = $ARGV[0];
my $metric = $ARGV[1];
my $shard = $ARGV[2];

unless($metaNodeUrl && $metric){
    print("Arguments Error!\n"); exit 1;
}

my $nodeStatistics = getNodeStatistics($metaNodeUrl);
unless($nodeStatistics){
    print("Could not fetch node statistics from $metaNodeUrl\n"); exit 2;
}

my $shardInfo = %$nodeStatistics{"shardStatistics"};
my $retVal;

if(looks_like_number($shard)){
    for(my $i=0; $i < scalar @$shardInfo; $i++){
        my $shardStats = @$shardInfo[$i];
        my $shardId = %$shardStats{"shardID"};
        if($shardId == $shard){
            $nodeStatistics = @$shardInfo[$shard];
            last;
        }
    }
}

$retVal = %$nodeStatistics{$metric};

unless(defined($retVal)){
    print("Undefined return value!\n"); exit 3;
}

print "$retVal\n";

exit 0;
