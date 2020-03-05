#!/usr/bin/perl -w
use LWP::Simple;
use JSON;
use Storable;
use Try::Tiny;
use Getopt::Std;

my $cacheFile = "/var/run/elrond_nodes";
my $nodesRef;
my %nodesRef;
my $expire;

getopts("e:" => \%opts);

if(defined($opts{"e"})){
    $expire = $opts{"e"} * 3600;
}
else{
    $expire = 60;
}

try {
    $nodesRef = retrieve($cacheFile);
    %nodes = %$nodesRef;
}
catch {};

my @netLines = split/\n/,`sudo /bin/netstat -antp`;

my @ports;
foreach my $netLine (@netLines){
    push(@ports, $1) if $netLine =~ /127\.0\.0\.1:([0-9]+).*LISTEN.*\/node/;
}

foreach my $port (@ports) {
    $nodeUrl = "http://localhost:" . $port . "/node/status";
    $content = get($nodeUrl);
    my $jsonObj = from_json($content);
    my $values = %$jsonObj{'details'};
    if(!defined($values)){
	print("Could not find details element from response. Exiting...\n");
        exit 0;
    }
    my $name = %$values{"erd_node_display_name"};
    if(!defined($name) || $name eq ""){
	next;
    }
    $nodes{$port} = ($name . "," . time());
}

foreach my $port (keys %nodes){
    my @nodeInfo = split/,/,$nodes{$port};
    my $lastSeen = $nodeInfo[1];
    my $timeDiff = time() - $lastSeen;
    if( $timeDiff >= $expire){
	delete $nodes{$port};
    }
}

my $jsonString = "[";
foreach my $port (keys %nodes){
    my @nodeInfo = split/,/,$nodes{$port};
    my $nodeName = $nodeInfo[0];
    $jsonString = $jsonString . "{\"{#NODENAME}\":\"$nodeName\",\"{#NODEPORT}\":\"$port\"},";
}
$jsonString =~ s/,+$//;
print ($jsonString . "]\n");
try{
    store(\%nodes, $cacheFile);
}
catch{};

exit 1;
