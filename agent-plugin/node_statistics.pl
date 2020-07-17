#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Scalar::Util qw(looks_like_number);
use ERD::Utils;
use ERD::Api;

my $nodeUrl = $ARGV[0];
my $metric = $ARGV[1];
my $shard = $ARGV[2];
unless($nodeUrl && $metric){
    print("0\n"); exit 1;
}

my $nodeStatistics = getNodeStatistics($nodeUrl);
unless($nodeStatistics){
    print("0\n"); exit 2;
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

unless($retVal || looks_like_number($retVal)){
    print("0\n"); exit 3;
}

print "$retVal\n";
exit 0;
