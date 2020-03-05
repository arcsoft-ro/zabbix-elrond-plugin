#!/usr/bin/perl -w

use LWP::Simple;
use JSON;

my @netLines = split/\n/,`sudo /bin/netstat -antp`;

my @ports;
foreach my $netLine (@netLines){
    push(@ports, $1) if $netLine =~ /127\.0\.0\.1:([0-9]+).*LISTEN.*\/node/;
}

my $jsonString = "[";

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
	print("Could not find metric erd_node_display_name in response from node. Exiting...\n");
        exit 0;
    }
    $jsonString = $jsonString . "{\"{#NODENAME}\":\"$name\",\"{#NODEPORT}\":\"$port\"},";
}

$jsonString =~ s/,+$//;

print $jsonString . "]";

exit 1;
