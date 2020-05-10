#!/usr/bin/perl -w
package ERD::Utils;
require Exporter;
@ISA	= qw(Exporter);
@EXPORT	= qw(
    $cacheRoot
    $nsExpireDefault
    $vsExpireDefault
    $nsNameSpace
    $vsNameSpace
    $nsKeyPrefix
    $vsKeyPrefix
    $hostName
    $pubKeyProp
    configLineContains
    startsWith
);

use LWP::Simple;
use JSON;
use Sys::Hostname;

######
# Global Configuration
######
our $cacheRoot = "/var/run/zabbix/erd_cache";
our $nsExpireDefault = 60;
our $vsExpireDefault = 3600;
our $nsNameSpace = "ERD_NODESTATUS";
our $vsNameSpace = "ERD_VALIDATORSTATISTICS";
our $nsKeyPrefix = "nodeStatus-";
our $vsKeyPrefix = "nodesStatistics";
our $hostName = hostname;
our $pubKeyProp = "erd_public_key_block_sign";

######
# Returns true if a config line matches a search string (ignoring comented lines with #)
######
sub configLineContains{
    my $line = $_[0];
    my $searchString = $_[1];
    if($line =~ /^\s*[^#].+\Q$searchString\E.+$/){
	return 1;
    }
    return 0;
}

sub startsWith{
    return substr($_[0], 0, length($_[1])) eq $_[1];
}

1;
