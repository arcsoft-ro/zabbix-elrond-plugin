#!/usr/bin/perl -w
package ERD::Api;
require Exporter;
@ISA	= qw(Exporter);
@EXPORT	= qw(
    getNodeStatus
    getValidatorStatistics
);

use LWP::Simple;
use JSON;

######
# Gets the node status
######
sub getNodeStatus{
    my $proto = $_[0];
    my $ipAddr = $_[1];
    my $port = $_[2];
    unless($proto && $ipAddr && $port){
	return undef;
    }
    my $nodeUrl = $proto . "://" . $ipAddr . ":" . $port . "/node/status";
    $content = get($nodeUrl);
    if($content){
        $nodeStatus = from_json($content);
        return %$nodeStatus{"details"};
    }
    return undef;
}

######
# Gets the validator statistics
######
sub getValidatorStatistics{
    my $metaNodeUrl = $_[0] ? $_[0] : "https://wallet-api.elrond.com/validator/statistics";
    $content = get($metaNodeUrl);
    if($content){
        $nodeStatus = from_json($content);
        return %$nodeStatus{"statistics"};
    }
    return undef;
}


1;
