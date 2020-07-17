#!/usr/bin/perl -w
use lib "/usr/bin/erd";
use Cache::FileCache;
use ERD::Utils;
use ERD::Api;

my $nsExpire = $ARGV[0] ? $ARGV[0] : $nsExpireDefault;

my $nsCache = new Cache::FileCache( {
    "cache_root" => $cacheRoot,
    "namespace" => $nsNameSpace,
    "default_expires_in" => $nsExpire
});

my $serviceConfigDir = "/etc/systemd/system/";

opendir(DIR, $serviceConfigDir);
@configFiles = grep(/elrond-node-.*\.service$/, readdir(DIR));
closedir(DIR);

my $jsonString = "[";
foreach my $configFile(@configFiles){
    open my $fh, '<', $serviceConfigDir . $configFile or die "Cannot open file: $!\n";
    while(<$fh>) {
        if(configLineContains($_,"rest-api-interface")){
            chomp;
            my @parts = split(/:/,$_);
            my $port = $parts[1];
            @parts = split(/\s+/,$parts[0]);
            my $host = $parts[$#parts];
            if($host eq "0.0.0.0"){
                $host = "127.0.0.1";
            }
            $nodeName = $hostName . ":" . $port;
            $jsonString .= "{\"{#NODENAME}\":\"$nodeName\",\"{#NODEIP}\":\"$host\",\"{#NODEPORT}\":\"$port\"},";
        }
    }
}

$jsonString =~ s/,+$//;
print ($jsonString . "]\n");
exit 0;
