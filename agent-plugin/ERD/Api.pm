#!/usr/bin/perl -w
package ERD::Api;
require Exporter;
@ISA	= qw(Exporter);
@EXPORT	= qw(
    getNodeStatus
    getNodeStatistics
    getValidatorStatistics
    getHeartBeatStatus
);

use LWP::Simple;
use JSON;

######
# Gets the node status
######
sub getNodeStatus{
    my $proto = $_[0];
    my $host = $_[1];
    my $port = $_[2];
    unless($proto && $host && $port){
        return undef;
    }
    my $nodeUrl = $proto . "://" . $host . ":" . $port . "/node/status";
    my $content = get($nodeUrl);
    if($content){
        my $responseJson = from_json($content);
        my $dataObject = %$responseJson{"data"};
        return %$dataObject{"metrics"};
    }
    return undef;
}

######
# Gets the node statistics
######
sub getNodeStatistics{
    unless($_[0]){
        return undef;
    }
    my $nodeUrl = $_[0] . "/node/statistics";
    my $content = get($nodeUrl);
    if($content){
        my $responseJson = from_json($content);
        my $dataObject = %$responseJson{"data"};
        return %$dataObject{"statistics"};
    }
    return undef;
}


######
# Gets the validator statistics
######
sub getValidatorStatistics{
    unless($_[0]){
        return undef;
    }
    my $metaNodeUrl = $_[0] . "/validator/statistics";
    my $content = get($metaNodeUrl);
    if($content){
        my $responseJson = from_json($content);
        my $dataObject = %$responseJson{"data"};
        return %$dataObject{"statistics"};
    }
    return undef;
}

######
# Gets the node heart beats
######
sub getHeartBeatStatus{
    unless($_[0]){
        return undef;
    }
    my $nodeUrl = $_[0] . "/node/heartbeatstatus";
    my $content = get($nodeUrl);
    if($content){
        my $responseJson = from_json($content);
        my $dataObject = %$responseJson{"data"};
        return %$dataObject{"heartbeats"};
    }
    return undef;
}

1;
