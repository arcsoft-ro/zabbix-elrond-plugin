#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use ERD::Utils;
use ERD::Api;

my $nodeUrl = $ARGV[0];
unless($nodeUrl){
    print("0\n"); exit 1;
}

my $nodeStatistics = getNodeStatistics($nodeUrl);
unless($nodeStatistics){
    print("0\n"); exit 2;
}

my $shardInfo = %$nodeStatistics{"nrOfShards"};
my $jsonString = "[";

for(my $i=0; $i < $shardInfo; $i++){
    $jsonString .= "{\"{#SHARDID}\":\"$i\"},";
}

$jsonString =~ s/,+$//;
$jsonString .= "]\n";
print $jsonString;

exit 0;
