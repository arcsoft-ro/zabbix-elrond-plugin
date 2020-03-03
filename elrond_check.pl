#!/usr/bin/perl -w
use Getopt::Std;
use LWP::Simple;
use JSON;

my $path = "/node/status";

sub startsWith{
    return substr($_[0], 0, length($_[1])) eq $_[1];
}

sub validArg{
    if(defined($_[0]) && $_[0] ne "" && !startsWith($_[0],"-")){
        return 1;
    }
    return 0;
}

getopts("m:n:p:h:"	=> \%opts);
my $node = $opts{"n"};
my $metric = $opts{"m"};
my $proto = $opts{"p"};
my $host = $opts{"h"};

if(!validArg($node)){
    $node = "8080";
}

if(!validArg($metric)){
    print("Missing arguments. Metric not provided with -m.\n");
    exit 0;
}
if(!validArg($proto)){
    $proto = "http";
}
if(!validArg($host)){
    $host = "localhost";
}

$nodeAddr = $proto . "://" . $host . ":" . $node . $path;
$content = get($nodeAddr);

my $jsonObj = from_json($content);
my $values = %$jsonObj{'details'};
if(!defined($values)){
    print("Could not find details element from response. Exiting...\n");
    exit 0;
}

my $retVal;
if($metric eq "erd_new_version_exists"){
    my $version = %$values{"erd_app_version"};
    my $latestVersion = %$values{"erd_latest_tag_software_version"};
    if(startsWith($version, $latestVersion)){
	$retVal = 0;
    }
    else{
	$retVal = 1;
    }
}
else{
    $retVal = %$values{$metric};
}

if(!defined($retVal) || $retVal eq ""){
    print("Could not find metric $metric in response from node. Exiting...\n");
    exit 0;
}
print "$retVal\n";
exit 1;
