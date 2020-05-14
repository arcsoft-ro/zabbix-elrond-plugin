#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Getopt::Long;
use Cache::FileCache;
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
my $retVal;
if(looks_like_number($shard)){
    $shardInfo = %$nodeStatistics{"shardStatistics"};
    $nodeStatistics = @$shardInfo[$shard];
}
$retVal = %$nodeStatistics{$metric};

unless($retVal || looks_like_number($retVal)){
    print("0\n"); exit 3;
}

print "$retVal\n";
exit 0;
