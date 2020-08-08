#!/usr/bin/perl -w
package ERD::Utils;
require Exporter;
@ISA	= qw(Exporter);
@EXPORT	= qw(
    $cacheRoot
    $nsExpireDefault
    $vsExpireDefault
    $hsExpireDefault
    $nsNameSpace
    $vsNameSpace
    $hsNameSpace
    $nsKeyPrefix
    $vsKeyPrefix
    $hsKeyPrefix
    $hostName
    $pubKeyProp
    configLineContains
    startsWith
    getRepoInfo
);

use LWP::Simple;
use JSON;
use Sys::Hostname;

######
# Global Configuration
######
our $cacheRoot = "/var/run/zabbix/erd_cache";
our $nsExpireDefault = 58;
our $vsExpireDefault = 295;
our $hsExpireDefault = 295;
our $nsNameSpace = "ERD_NODESTATUS";
our $vsNameSpace = "ERD_VALIDATORSTATISTICS";
our $hsNameSpace = "ERD_HEARTBEATSTATISTICS";
our $nsKeyPrefix = "nodeStatus-";
our $vsKeyPrefix = "validatorStatistics-";
our $hsKeyPrefix = "heartbeatStatistics-";
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

######
# Checks if string1 starts with string2
######
sub startsWith{
    return substr($_[0], 0, length($_[1])) eq $_[1];
}

######
# Gets the version tag from GitHub
######
sub getRepoInfo{
    unless($_[0] && $_[1]){
        return undef;
    }
    my $url = $_[0];
    my $dataObject = $_[1];
    my $content = get($url);
    if($content){
        my $responseJson = from_json($content);
        return %$responseJson{$dataObject};
    }
    return undef;
}

1;
